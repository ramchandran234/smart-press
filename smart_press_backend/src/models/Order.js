// src/models/Order.js
const mongoose = require('mongoose');

const garmentSchema = new mongoose.Schema({
  name:    { type: String, required: true },
  qty:     { type: Number, required: true, min: 1 },
  rate:    { type: Number, required: true },
  service: { type: String },
  amount:  { type: Number },
});

const statusHistorySchema = new mongoose.Schema({
  status:    { type: String },
  note:      { type: String },
  updatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  time:      { type: Date, default: Date.now },
});

const orderSchema = new mongoose.Schema({
  orderId: {
    type: String,
    unique: true,
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  customer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Customer',
    required: true,
  },
  garments:    [garmentSchema],
  orderType: {
    type: String,
    enum: ['walk-in', 'pickup', 'delivery'],
    default: 'walk-in',
  },
  serviceType: { type: String },
  status: {
    type: String,
    enum: [
      'received', 'washing', 'ironing',
      'ready', 'delivered', 'cancelled'
    ],
    default: 'received',
  },
  statusHistory: [statusHistorySchema],
  // Amounts
  subtotal:       { type: Number, default: 0 },
  deliveryCharge: { type: Number, default: 0 },
  discount:       { type: Number, default: 0 },
  totalAmount:    { type: Number, default: 0 },
  paidAmount:     { type: Number, default: 0 },
  isPaid:         { type: Boolean, default: false },
  paymentMode:    { type: String },
  paymentDate:    { type: Date },
  // Dates
  expectedDate: { type: Date },
  deliveredAt:  { type: Date },
  // Logistics
  pickupDate:   { type: Date },
  pickupSlot:   { type: String },
  deliveryDate: { type: Date },
  deliverySlot: { type: String },
  pickupAddress:   { type: String },
  deliveryAddress: { type: String },
  // Extra
  notes:  { type: String },
  qrCode: { type: String },
}, {
  timestamps: true,
});

// Auto-generate orderId before saving
orderSchema.pre('save', async function (next) {
  if (!this.orderId) {
    const count = await mongoose.model('Order')
      .countDocuments();
    this.orderId =
      `ORD${String(count + 1).padStart(3, '0')}`;
  }
  next();
});

module.exports = mongoose.model('Order', orderSchema);