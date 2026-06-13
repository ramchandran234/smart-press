// src/controllers/report.controller.js
const Order   = require('../models/Order');
const Expense = require('../models/Expense');
const Invoice = require('../models/Invoice');
const Customer= require('../models/Customer');

// ── Revenue Dashboard ───────────────────────────────────
exports.getRevenue = async (req, res) => {
  try {
    const { period = 'month' } = req.query;
    const ownerId = req.user.id;

    // Date range
    const now = new Date();
    let startDate;
    if (period === 'today') {
      startDate = new Date(now.setHours(0, 0, 0, 0));
    } else if (period === 'week') {
      startDate = new Date(now.setDate(now.getDate() - 7));
    } else {
      startDate = new Date(now.setDate(1));
    }

    // Revenue from paid orders
    const orders = await Order.find({
      owner: ownerId,
      isPaid: true,
      paymentDate: { $gte: startDate },
    });

    const revenue = orders.reduce(
      (sum, o) => sum + o.paidAmount, 0
    );
    const orderCount = orders.length;
    const avgOrder = orderCount > 0
      ? Math.round(revenue / orderCount)
      : 0;

    // By order type
    const walkIn   = orders.filter(
      o => o.orderType === 'walk-in'
    ).reduce((s, o) => s + o.paidAmount, 0);
    const pickup   = orders.filter(
      o => o.orderType === 'pickup'
    ).reduce((s, o) => s + o.paidAmount, 0);
    const delivery = orders.filter(
      o => o.orderType === 'delivery'
    ).reduce((s, o) => s + o.paidAmount, 0);

    res.json({
      success: true,
      data: {
        revenue,
        orderCount,
        avgOrder,
        byChannel: { walkIn, pickup, delivery },
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Profit Summary ──────────────────────────────────────
exports.getProfit = async (req, res) => {
  try {
    const ownerId = req.user.id;
    const now = new Date();
    const startOfMonth = new Date(
      now.getFullYear(), now.getMonth(), 1
    );

    const orders = await Order.find({
      owner: ownerId,
      isPaid: true,
      paymentDate: { $gte: startOfMonth },
    });
    const revenue = orders.reduce(
      (s, o) => s + o.paidAmount, 0
    );

    const expenses = await Expense.find({
      owner: ownerId,
      expenseDate: { $gte: startOfMonth },
    });
    const totalExpenses = expenses.reduce(
      (s, e) => s + e.amount, 0
    );

    const profit = revenue - totalExpenses;
    const margin = revenue > 0
      ? Math.round((profit / revenue) * 100)
      : 0;

    // Breakdown by category
    const breakdown = {};
    expenses.forEach((e) => {
      breakdown[e.category] =
        (breakdown[e.category] || 0) + e.amount;
    });

    res.json({
      success: true,
      data: {
        revenue,
        totalExpenses,
        profit,
        margin,
        breakdown,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Receivables ─────────────────────────────────────────
exports.getReceivables = async (req, res) => {
  try {
    const unpaid = await Invoice.find({
      owner: req.user.id,
      isPaid: false,
    })
      .populate('customer', 'name mobile')
      .sort({ createdAt: 1 });

    const total = unpaid.reduce(
      (s, i) => s + i.totalAmount, 0
    );

    res.json({ success: true, invoices: unpaid, total });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};