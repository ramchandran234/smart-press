// src/controllers/customer.controller.js
const Customer = require('../models/Customer');
const Order    = require('../models/Order');
const mongoose = require('mongoose');
const memoryDb = require('../utils/memoryDb');

exports.getAllCustomers = async (req, res) => {
  try {
    const { search, page = 1, limit = 20 } = req.query;

    if (mongoose.connection.readyState === 1) {
      const filter = { owner: req.user.id };
      if (search) {
        filter.$or = [
          { name:   { $regex: search, $options: 'i' } },
          { mobile: { $regex: search, $options: 'i' } },
        ];
      }
      const customers = await Customer.find(filter)
        .sort({ createdAt: -1 })
        .limit(Number(limit))
        .skip((Number(page) - 1) * Number(limit));

      const total = await Customer.countDocuments(filter);
      return res.json({ success: true, customers, total });
    }

    // In-memory fallback
    let list = memoryDb.customers.filter(c => c.owner === req.user.id || c.owner?._id === req.user.id);
    if (search) {
      const s = search.toLowerCase();
      list = list.filter(c => (c.name && c.name.toLowerCase().includes(s)) || (c.mobile && c.mobile.includes(s)));
    }
    res.json({ success: true, customers: list, total: list.length });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.createCustomer = async (req, res) => {
  try {
    if (mongoose.connection.readyState === 1) {
      const existing = await Customer.findOne({
        owner: req.user.id,
        mobile: req.body.mobile,
      });

      if (existing) {
        return res.status(400).json({
          success: false,
          error: 'Customer with this mobile already exists',
        });
      }

      const customer = await Customer.create({
        ...req.body,
        owner: req.user.id,
      });
      return res.status(201).json({ success: true, customer });
    }

    // In-memory fallback
    const newCustomer = {
      _id: memoryDb.generateId(),
      owner: req.user.id,
      totalOrders: 0,
      totalSpend: 0,
      balance: 0,
      isActive: true,
      createdAt: new Date(),
      ...req.body,
    };
    memoryDb.customers.push(newCustomer);
    res.status(201).json({ success: true, customer: newCustomer });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.getCustomerById = async (req, res) => {
  try {
    const customer = await Customer.findById(req.params.id);
    if (!customer) {
      return res.status(404).json({
        success: false,
        error: 'Customer not found',
      });
    }
    res.json({ success: true, customer });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.updateCustomer = async (req, res) => {
  try {
    const customer = await Customer.findByIdAndUpdate(
      req.params.id, req.body, { new: true }
    );
    res.json({ success: true, customer });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.getCustomerOrders = async (req, res) => {
  try {
    const orders = await Order.find({
      customer: req.params.id,
      owner: req.user.id,
    }).sort({ createdAt: -1 });
    res.json({ success: true, orders });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};