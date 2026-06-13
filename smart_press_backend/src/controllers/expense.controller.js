// src/controllers/expense.controller.js
const Expense  = require('../models/Expense');
const Supplier = require('../models/Supplier');

exports.getAllExpenses = async (req, res) => {
  try {
    const { category, from, to } = req.query;
    const filter = { owner: req.user.id };

    if (category) filter.category = category;
    if (from || to) {
      filter.expenseDate = {};
      if (from) filter.expenseDate.$gte = new Date(from);
      if (to)   filter.expenseDate.$lte = new Date(to);
    }

    const expenses = await Expense.find(filter)
      .populate('supplier', 'name category')
      .sort({ expenseDate: -1 });

    const total = expenses.reduce(
      (sum, e) => sum + e.amount, 0
    );

    res.json({ success: true, expenses, total });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.createExpense = async (req, res) => {
  try {
    const expense = await Expense.create({
      ...req.body,
      owner: req.user.id,
    });

    // Update supplier balance if linked
    if (req.body.supplierId) {
      await Supplier.findByIdAndUpdate(req.body.supplierId, {
        $inc: { balance: req.body.amount }
      });
    }

    res.status(201).json({ success: true, expense });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};