// src/controllers/supplier.controller.js
const Supplier = require('../models/Supplier');

exports.getAllSuppliers = async (req, res) => {
  try {
    const suppliers = await Supplier.find({
      owner: req.user.id
    }).sort({ createdAt: -1 });
    res.json({ success: true, suppliers });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.createSupplier = async (req, res) => {
  try {
    const supplier = await Supplier.create({
      ...req.body,
      owner: req.user.id,
      balance: req.body.openingBalance || 0,
    });
    res.status(201).json({ success: true, supplier });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.getSupplierById = async (req, res) => {
  try {
    const supplier = await Supplier.findById(req.params.id);
    if (!supplier) {
      return res.status(404).json({
        success: false,
        error: 'Supplier not found',
      });
    }
    res.json({ success: true, supplier });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.recordPayment = async (req, res) => {
  try {
    const { amount, mode, reference, note } = req.body;

    const supplier = await Supplier.findById(req.params.id);
    if (!supplier) {
      return res.status(404).json({
        success: false,
        error: 'Supplier not found',
      });
    }

    supplier.paymentHistory.push({
      amount, mode, reference, note,
      paidAt: new Date(),
    });
    supplier.balance   -= amount;
    supplier.totalPaid += amount;
    await supplier.save();

    res.json({ success: true, supplier });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};