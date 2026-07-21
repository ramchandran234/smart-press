// src/models/Invoice.js
const mongoose = require('mongoose');

const invoiceSchema = new mongoose.Schema({
  invoiceId: {
    type: String,
    unique: true,
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  order: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order',
    required: true,
  },
  customer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Customer',
    required: true,
  },
  subtotal:       { type: Number, required: true },
  deliveryCharge: { type: Number, default: 0 },
  discount:       { type: Number, default: 0 },
  totalAmount:    { type: Number, required: true },
  isPaid:         { type: Boolean, default: false },
  paidAt:         { type: Date },
  dueDate:        { type: Date },
  pdfUrl:         { type: String },
  sharedVia:      { type: [String], default: [] },
}, {
  timestamps: true,
});

// Auto-generate invoiceId
invoiceSchema.pre('save', async function () {
  if (!this.invoiceId) {
    const count = await mongoose.model('Invoice')
      .countDocuments();
    this.invoiceId =
      `INV${String(count + 1).padStart(3, '0')}`;
  }
});

module.exports = mongoose.model('Invoice', invoiceSchema);