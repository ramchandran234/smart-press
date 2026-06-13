// src/models/Supplier.js
const mongoose = require('mongoose');

const paymentHistorySchema = new mongoose.Schema({
  amount:    { type: Number, required: true },
  mode:      { type: String },
  reference: { type: String },
  note:      { type: String },
  screenshot:{ type: String },
  paidAt:    { type: Date, default: Date.now },
});

const supplierSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name:     { type: String, required: true, trim: true },
  category: {
    type: String,
    enum: ['Detergent', 'Transport', 'Equipment',
           'Packaging', 'Other'],
    default: 'Other',
  },
  mobile:   { type: String },
  address:  { type: String },
  upiId:    { type: String },
  bankAccount: { type: String },
  ifscCode:    { type: String },
  qrImage:     { type: String },
  openingBalance: { type: Number, default: 0 },
  balance:        { type: Number, default: 0 },
  totalPaid:      { type: Number, default: 0 },
  paymentHistory: [paymentHistorySchema],
  isActive: { type: Boolean, default: true },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Supplier', supplierSchema);