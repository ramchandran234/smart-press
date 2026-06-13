// src/controllers/auth.controller.js
const User          = require('../models/User');
const generateToken = require('../utils/generateToken');

// ── Send OTP ────────────────────────────────────────────
exports.sendOtp = async (req, res) => {
  try {
    const { mobile, role } = req.body;

    if (!mobile) {
      return res.status(400).json({
        success: false,
        error: 'Mobile number is required',
      });
    }

    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000)
      .toString();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 min

    // Save OTP to user (create if new)
    await User.findOneAndUpdate(
      { mobile },
      { otp, otpExpiry, role: role || 'customer' },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );

    // TODO: Send real SMS using Twilio or MSG91
    // For development, log the OTP
    console.log(`📱 OTP for ${mobile}: ${otp}`);

    res.json({
      success: true,
      message: 'OTP sent successfully',
      // Remove otp from production response!
      otp: otp,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Verify OTP ──────────────────────────────────────────
exports.verifyOtp = async (req, res) => {
  try {
    const { mobile, otp } = req.body;

    if (!mobile || !otp) {
      return res.status(400).json({
        success: false,
        error: 'Mobile and OTP are required',
      });
    }

    const user = await User.findOne({ mobile });

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found. Please send OTP first.',
      });
    }

    // Check OTP
    if (user.otp !== otp) {
      return res.status(400).json({
        success: false,
        error: 'Invalid OTP',
      });
    }

    // Check OTP expiry
    if (user.otpExpiry < new Date()) {
      return res.status(400).json({
        success: false,
        error: 'OTP expired. Please request a new one.',
      });
    }

    // Clear OTP after successful verification
    user.otp = undefined;
    user.otpExpiry = undefined;
    if (!user.name || user.name === 'New User') {
      user.name = 'User';
    }
    await user.save();

    const token = generateToken(user._id, user.role);

    res.json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        id:         user._id,
        name:       user.name,
        mobile:     user.mobile,
        role:       user.role,
        shopName:   user.shopName,
        isVerified: user.isVerified,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Get Profile ─────────────────────────────────────────
exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id)
      .select('-otp -otpExpiry -__v');
    res.json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Update Profile ──────────────────────────────────────
exports.updateProfile = async (req, res) => {
  try {
    const updates = [
      'name', 'shopName', 'address', 'city',
      'upiId', 'gstin', 'fcmToken'
    ];
    const updateData = {};
    updates.forEach((field) => {
      if (req.body[field] !== undefined) {
        updateData[field] = req.body[field];
      }
    });

    const user = await User.findByIdAndUpdate(
      req.user.id,
      updateData,
      { new: true, runValidators: true }
    ).select('-otp -otpExpiry -__v');

    res.json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};