// src/models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
  },
  mobile: {
    type: String,
    required: [true, 'Mobile is required'],
    unique: true,
    trim: true,
  },
  password: {
    type: String,
    trim: true,
  },
  role: {
    type: String,
    enum: ['owner', 'customer'],
    default: 'customer',
  },
  // Owner & Customer fields
  shopName:     { type: String, trim: true },
  shopImage:    { type: String },
  addressLine1: { type: String, trim: true },
  area:         { type: String, trim: true },
  address:      { type: String },
  city:         { type: String },
  gstin:      { type: String },
  upiId:      { type: String },
  qrImage:    { type: String },
  isVerified: { type: Boolean, default: false },
  isActive:   { type: Boolean, default: true },
  // Push notifications
  fcmToken:   { type: String },
  // OTP fields
  otp:        { type: String },
  otpExpiry:  { type: Date },
  recoveryPin: { type: String },
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);