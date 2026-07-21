// src/controllers/order.controller.js
const Order    = require('../models/Order');
const Customer = require('../models/Customer');
const Invoice  = require('../models/Invoice');

// ── Get All Orders ──────────────────────────────────────
exports.getAllOrders = async (req, res) => {
  try {
    const {
      status, type,
      page = 1, limit = 20,
      search
    } = req.query;

    const filter = { owner: req.user.id };
    if (status) filter.status = status;
    if (type)   filter.orderType = type;

    const orders = await Order.find(filter)
      .populate('customer', 'name mobile area')
      .sort({ createdAt: -1 })
      .limit(Number(limit))
      .skip((Number(page) - 1) * Number(limit));

    const total = await Order.countDocuments(filter);

    res.json({
      success: true,
      orders,
      pagination: {
        total,
        page: Number(page),
        pages: Math.ceil(total / Number(limit)),
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Create Order ────────────────────────────────────────
exports.createOrder = async (req, res) => {
  try {
    const {
      customerId, garments, orderType,
      serviceType, deliveryCharge, discount,
      pickupDate, pickupSlot, deliveryDate,
      deliverySlot, expectedDate, notes,
    } = req.body;

    // Calculate totals
    const subtotal = garments.reduce(
      (sum, g) => sum + (g.qty * g.rate), 0
    );
    const totalAmount = subtotal +
      (deliveryCharge || 0) - (discount || 0);

    const order = await Order.create({
      owner:        req.user.id,
      customer:     customerId,
      garments:     garments.map(g => ({
        ...g,
        amount: g.qty * g.rate
      })),
      orderType,
      serviceType,
      subtotal,
      deliveryCharge: deliveryCharge || 0,
      discount:       discount || 0,
      totalAmount,
      pickupDate,
      pickupSlot,
      deliveryDate,
      deliverySlot,
      expectedDate,
      notes,
      statusHistory: [{
        status: 'received',
        note: 'Order created',
        updatedBy: req.user.id,
      }],
    });

    // Update customer stats
    await Customer.findByIdAndUpdate(customerId, {
      $inc: {
        totalOrders: 1,
        totalSpend: totalAmount,
        balance: totalAmount,
      },
      lastOrderAt: new Date(),
    });

    // Auto-create invoice
    await Invoice.create({
      owner:          req.user.id,
      order:          order._id,
      customer:       customerId,
      subtotal,
      deliveryCharge: deliveryCharge || 0,
      discount:       discount || 0,
      totalAmount,
      dueDate: expectedDate,
    });

    const populated = await Order.findById(order._id)
      .populate('customer', 'name mobile');

    res.status(201).json({ success: true, order: populated });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Get Order by ID ─────────────────────────────────────
exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('customer', 'name mobile area address');

    if (!order) {
      return res.status(404).json({
        success: false,
        error: 'Order not found',
      });
    }

    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Update Order Status ─────────────────────────────────
exports.updateStatus = async (req, res) => {
  try {
    const { status, note, notifyCustomer } = req.body;

    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({
        success: false,
        error: 'Order not found',
      });
    }

    order.status = status;
    order.statusHistory.push({
      status,
      note: note || '',
      updatedBy: req.user.id,
      time: new Date(),
    });

    if (status === 'delivered') {
      order.deliveredAt = new Date();
    }

    await order.save();

    // TODO: Send push notification if notifyCustomer = true

    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Get Order History ───────────────────────────────────
exports.getOrderHistory = async (req, res) => {
  try {
    const { from, to, page = 1, limit = 20 } = req.query;
    const filter = {
      owner: req.user.id,
      status: { $in: ['delivered', 'cancelled'] },
    };

    if (from || to) {
      filter.createdAt = {};
      if (from) filter.createdAt.$gte = new Date(from);
      if (to)   filter.createdAt.$lte = new Date(to);
    }

    const orders = await Order.find(filter)
      .populate('customer', 'name mobile')
      .sort({ createdAt: -1 })
      .limit(Number(limit))
      .skip((Number(page) - 1) * Number(limit));

    res.json({ success: true, orders });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Collect Payment ─────────────────────────────────────
exports.collectPayment = async (req, res) => {
  try {
    const { amount, paymentMode } = req.body;

    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({
        success: false,
        error: 'Order not found',
      });
    }

    order.paidAmount  = amount;
    order.isPaid      = amount >= order.totalAmount;
    order.paymentMode = paymentMode;
    order.paymentDate = new Date();
    await order.save();

    // Update customer balance
    if (order.isPaid) {
      await Customer.findByIdAndUpdate(order.customer, {
        $inc: { balance: -order.totalAmount }
      });

      // Mark invoice as paid
      await Invoice.findOneAndUpdate(
        { order: order._id },
        { isPaid: true, paidAt: new Date() }
      );
    }

    res.json({ success: true, order });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// Get orders for the logged-in customer app user
exports.getCustomerOrdersForApp = async (req, res) => {
  try {
    const cleanMobile = req.user.mobile;
    
    // Find all customer profiles created by owners for this mobile number
    const customerProfiles = await Customer.find({ mobile: cleanMobile });
    const customerIds = customerProfiles.map(c => c._id);
    
    const orders = await Order.find({ customer: { $in: customerIds } })
      .populate('owner', 'name shopName address mobile')
      .populate('customer', 'name mobile area')
      .sort({ createdAt: -1 });
      
    res.json({
      success: true,
      orders
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// Customer places an order to a vendor/owner
exports.customerCreateOrder = async (req, res) => {
  try {
    const {
      ownerId, garments, orderType,
      serviceType, notes,
    } = req.body;

    if (!ownerId || !garments) {
      return res.status(400).json({
        success: false,
        error: 'Owner ID and garments are required',
      });
    }

    // 1. Find or create a Customer profile under this owner for the logged-in customer's mobile
    let customerProfile = await Customer.findOne({ owner: ownerId, mobile: req.user.mobile });
    if (!customerProfile) {
      customerProfile = await Customer.create({
        owner: ownerId,
        name: req.user.name,
        mobile: req.user.mobile,
        whatsapp: req.user.mobile,
        isActive: true,
      });
    }

    // 2. Calculate totals (using a standard rate e.g. 40 per garment if not specified)
    const processedGarments = garments.map(g => {
      const rate = g.rate || 40;
      return {
        name: g.name,
        qty: Number(g.qty),
        rate: Number(rate),
        amount: Number(g.qty) * Number(rate),
        service: serviceType || 'Wash + Iron',
      };
    });

    const subtotal = processedGarments.reduce((sum, g) => sum + g.amount, 0);
    const totalAmount = subtotal;

    // 3. Create the order
    const order = await Order.create({
      owner:        ownerId,
      customer:     customerProfile._id,
      garments:     processedGarments,
      orderType:    orderType || 'walk-in',
      serviceType:  serviceType || 'Wash + Iron',
      subtotal,
      totalAmount,
      notes,
      statusHistory: [{
        status: 'received',
        note: 'Order placed by customer',
        updatedBy: req.user.id,
      }],
    });

    // 4. Update customer stats
    customerProfile.totalOrders += 1;
    customerProfile.totalSpend += totalAmount;
    customerProfile.balance += totalAmount;
    customerProfile.lastOrderAt = new Date();
    await customerProfile.save();

    // 5. Create invoice
    await Invoice.create({
      owner:       ownerId,
      order:       order._id,
      customer:    customerProfile._id,
      subtotal,
      totalAmount,
    });

    res.status(201).json({
      success: true,
      message: 'Order placed successfully',
      order,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};