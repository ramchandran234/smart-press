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
  role: {
    type: String,
    enum: ['owner', 'customer'],
    default: 'customer',
  },
  // Owner fields
  shopName:   { type: String, trim: true },
  shopImage:  { type: String },
  address:    { type: String },
  city:       { type: String },
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
}, {
  timestamps: true,
});

module.exports = mongoose.model('User', userSchema);