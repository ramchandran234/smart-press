// src/models/Customer.js
const mongoose = require('mongoose');

const customerSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name: {
    type: String,
    required: [true, 'Customer name is required'],
    trim: true,
  },
  mobile: {
    type: String,
    required: [true, 'Mobile is required'],
    trim: true,
  },
  whatsapp:      { type: String },
  addressLine1:  { type: String },
  area:          { type: String },
  city:          { type: String },
  landmark:      { type: String },
  notes:         { type: String },
  preferredSlot: { type: String },
  isActive:      { type: Boolean, default: true },
  // Stats (auto-updated)
  totalOrders: { type: Number, default: 0 },
  totalSpend:  { type: Number, default: 0 },
  balance:     { type: Number, default: 0 },
  lastOrderAt: { type: Date },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Customer', customerSchema);