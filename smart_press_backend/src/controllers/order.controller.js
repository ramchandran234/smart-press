// src/controllers/order.controller.js
const Order    = require('../models/Order');
const Customer = require('../models/Customer');
const Invoice  = require('../models/Invoice');
const User     = require('../models/User');
const mongoose = require('mongoose');
const memoryDb = require('../utils/memoryDb');

function calculateHaversineDistance(lat1, lon1, lat2, lon2) {
  if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return Math.round(R * c * 10) / 10;
}

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
      .populate('customer', 'name mobile area address')
      .populate('owner', 'name shopName mobile area city address');

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

    // Check owner open/closed status & distance
    let ownerUser;
    if (mongoose.connection.readyState === 1) {
      ownerUser = await User.findById(ownerId);
    } else {
      ownerUser = memoryDb.findUserById(ownerId);
    }

    if (ownerUser && ownerUser.isOpen === false) {
      return res.status(400).json({
        success: false,
        error: 'Shop is currently closed',
      });
    }

    // Calculate distance between customer and shop
    const custLat = req.body.customerLat != null ? Number(req.body.customerLat) : (req.user ? req.user.latitude : null);
    const custLng = req.body.customerLng != null ? Number(req.body.customerLng) : (req.user ? req.user.longitude : null);
    const ownerLat = ownerUser && ownerUser.latitude != null ? Number(ownerUser.latitude) : null;
    const ownerLng = ownerUser && ownerUser.longitude != null ? Number(ownerUser.longitude) : null;

    let distance = req.body.distance != null ? Number(req.body.distance) : 0;
    if (custLat != null && custLng != null && ownerLat != null && ownerLng != null) {
      distance = calculateHaversineDistance(custLat, custLng, ownerLat, ownerLng);
    }

    if (distance > 10.0) {
      return res.status(400).json({
        success: false,
        error: 'out of distance try another shop',
        distance,
      });
    }

    // 1. Find or create a Customer profile under this owner for the logged-in customer's mobile
    let customerProfile;
    if (mongoose.connection.readyState === 1) {
      customerProfile = await Customer.findOne({ owner: ownerId, mobile: req.user.mobile });
      if (!customerProfile) {
        customerProfile = await Customer.create({
          owner: ownerId,
          name: req.user.name,
          mobile: req.user.mobile,
          whatsapp: req.user.mobile,
          isActive: true,
        });
      }
    } else {
      customerProfile = memoryDb.customers.find(c => c.owner === ownerId && c.mobile === req.user.mobile);
      if (!customerProfile) {
        customerProfile = {
          _id: memoryDb.generateId(),
          owner: ownerId,
          name: req.user.name,
          mobile: req.user.mobile,
          whatsapp: req.user.mobile,
          totalOrders: 0,
          totalSpend: 0,
          balance: 0,
          isActive: true,
          createdAt: new Date(),
        };
        memoryDb.customers.push(customerProfile);
      }
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
    let order;
    if (mongoose.connection.readyState === 1) {
      order = await Order.create({
        owner:        ownerId,
        customer:     customerProfile._id,
        garments:     processedGarments,
        orderType:    orderType || 'walk-in',
        serviceType:  serviceType || 'Wash + Iron',
        subtotal,
        totalAmount,
        distance,
        notes,
        statusHistory: [{
          status: 'received',
          note: 'Order placed by customer',
          updatedBy: req.user.id,
        }],
      });
    } else {
      order = {
        _id: memoryDb.generateId(),
        orderId: `ORD${String(memoryDb.orders.length + 1).padStart(3, '0')}`,
        owner: ownerId,
        customer: customerProfile._id,
        garments: processedGarments,
        orderType: orderType || 'walk-in',
        serviceType: serviceType || 'Wash + Iron',
        subtotal,
        totalAmount,
        distance,
        notes,
        status: 'received',
        createdAt: new Date(),
      };
      memoryDb.orders.push(order);
    }

    // 4. Update customer stats & Invoice
    if (mongoose.connection.readyState === 1) {
      customerProfile.totalOrders += 1;
      customerProfile.totalSpend += totalAmount;
      customerProfile.balance += totalAmount;
      customerProfile.lastOrderAt = new Date();
      await customerProfile.save();

      await Invoice.create({
        owner:       ownerId,
        order:       order._id,
        customer:    customerProfile._id,
        subtotal,
        totalAmount,
      });
    } else {
      customerProfile.totalOrders = (customerProfile.totalOrders || 0) + 1;
      customerProfile.totalSpend = (customerProfile.totalSpend || 0) + totalAmount;
      customerProfile.balance = (customerProfile.balance || 0) + totalAmount;
      customerProfile.lastOrderAt = new Date();

      memoryDb.invoices.push({
        _id: memoryDb.generateId(),
        owner: ownerId,
        order: order._id,
        customer: customerProfile._id,
        subtotal,
        totalAmount,
        createdAt: new Date(),
      });
    }

    res.status(201).json({
      success: true,
      message: 'Order placed successfully',
      order,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};