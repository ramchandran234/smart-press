// src/models/Expense.js
const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  supplier: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Supplier',
  },
  description: { type: String, required: true },
  category: {
    type: String,
    enum: ['Detergent', 'Transport', 'Equipment',
           'Salary', 'Rent', 'Other'],
    default: 'Other',
  },
  amount:      { type: Number, required: true },
  paymentMode: {
    type: String,
    enum: ['UPI', 'Cash', 'Cheque', 'Bank Transfer'],
    default: 'Cash',
  },
  expenseDate: { type: Date, default: Date.now },
  receipt:     { type: String },
  notes:       { type: String },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Expense', expenseSchema);