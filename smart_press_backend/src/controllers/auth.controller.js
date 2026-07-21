// src/controllers/auth.controller.js
const User          = require('../models/User');
const generateToken = require('../utils/generateToken');
const axios         = require('axios'); // npm install axios
const { normalizeMobile, hashPassword, comparePassword } = require('../utils/authUtils');

exports.register = async (req, res) => {
  try {
    const { name, mobile, password, role, shopName, addressLine1, area, city } = req.body;

    if (!name || !mobile || !password) {
      return res.status(400).json({
        success: false,
        error: 'Name, mobile and password are required',
      });
    }

    const cleanMobile = normalizeMobile(mobile);
    if (cleanMobile.length !== 10) {
      return res.status(400).json({
        success: false,
        error: 'Enter a valid 10-digit mobile number',
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters',
      });
    }

    const existingUser = await User.findOne({ mobile: cleanMobile });
    if (existingUser) {
      return res.status(409).json({
        success: false,
        error: 'User already exists with this mobile number',
      });
    }

    const recoveryPin = Math.floor(100000 + Math.random() * 900000).toString();
    const hashedPassword = await hashPassword(password);
    const user = await User.create({
      name,
      mobile: cleanMobile,
      password: hashedPassword,
      role: role || 'customer',
      isVerified: true,
      shopName,
      addressLine1,
      area,
      city,
      address: addressLine1 || req.body.address,
      recoveryPin,
    });

    const token = generateToken(user._id, user.role);
    res.status(201).json({
      success: true,
      message: 'Registration successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        mobile: user.mobile,
        role: user.role,
        shopName: user.shopName,
        addressLine1: user.addressLine1,
        area: user.area,
        city: user.city,
        address: user.address,
        isVerified: user.isVerified,
        recoveryPin: user.recoveryPin,
      },
    });
  } catch (err) {
    console.error('register error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { mobile, password } = req.body;

    if (!mobile || !password) {
      return res.status(400).json({
        success: false,
        error: 'Mobile and password are required',
      });
    }

    const cleanMobile = normalizeMobile(mobile);
    const user = await User.findOne({ mobile: cleanMobile });

    if (!user || !user.password) {
      return res.status(401).json({
        success: false,
        error: 'Invalid mobile number or password',
      });
    }

    const isMatch = await comparePassword(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        error: 'Invalid mobile number or password',
      });
    }

    const token = generateToken(user._id, user.role);
    res.json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        mobile: user.mobile,
        role: user.role,
        shopName: user.shopName,
        addressLine1: user.addressLine1,
        area: user.area,
        city: user.city,
        address: user.address,
        isVerified: user.isVerified,
      },
    });
  } catch (err) {
    console.error('login error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Send OTP (Real SMS via Fast2SMS) ────────────────────
exports.sendOtp = async (req, res) => {
  try {
    const { mobile, role } = req.body;

    if (!mobile) {
      return res.status(400).json({
        success: false,
        error: 'Mobile number is required',
      });
    }

    // Clean mobile — digits only, strip +91
    const cleanMobile = mobile.replace(/\D/g, '').replace(/^91/, '');

    if (cleanMobile.length !== 10) {
      return res.status(400).json({
        success: false,
        error: 'Enter a valid 10-digit mobile number',
      });
    }

    // Generate 6-digit OTP
    const otp      = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 min

    // Save OTP to DB (create user if new)
    await User.findOneAndUpdate(
      { mobile: cleanMobile },
      { otp, otpExpiry, role: role || 'customer' },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    );

    // ── Send real SMS via Fast2SMS ──────────────────────
    const smsRes = await axios.post(
  'https://www.fast2sms.com/dev/bulkV2',
  {
    message:  `Your Smart Press OTP is ${otp}. Valid for 10 minutes.`,
    language: 'english',
    route:    'q',           // quick route — no DLT needed
    numbers:  cleanMobile,
  },
  {
    headers: {
      authorization:  process.env.FAST2SMS_API_KEY,
      'Content-Type': 'application/json',
    },
    timeout: 10000,
  }
);

    console.log(`📱 Fast2SMS response for ${cleanMobile}:`, smsRes.data);

    if (!smsRes.data.return) {
      console.error('Fast2SMS error:', smsRes.data);
      return res.status(500).json({
        success: false,
        error:   'SMS sending failed. Check FAST2SMS_API_KEY in Render env vars.',
      });
    }

    // ── Success — DO NOT return OTP in response ─────────
    res.json({
      success: true,
      message: `OTP sent to ${cleanMobile}`,
    });

  } catch (err) {
    console.error('sendOtp error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Send Password Reset OTP ─────────────────────────────
exports.sendResetOtp = async (req, res) => {
  try {
    const { mobile, role } = req.body;

    if (!mobile) {
      return res.status(400).json({
        success: false,
        error: 'Mobile number is required',
      });
    }

    const cleanMobile = mobile.replace(/\D/g, '').replace(/^91/, '');
    if (cleanMobile.length !== 10) {
      return res.status(400).json({
        success: false,
        error: 'Enter a valid 10-digit mobile number',
      });
    }

    const user = await User.findOne({ mobile: cleanMobile });
    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found with this mobile number',
      });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

    user.otp = otp;
    user.otpExpiry = otpExpiry;
    await user.save();

    const smsRes = await axios.post(
      'https://www.fast2sms.com/dev/bulkV2',
      {
        message: `Your Smart Press password reset OTP is ${otp}. Valid for 10 minutes.`,
        language: 'english',
        route: 'q',
        numbers: cleanMobile,
      },
      {
        headers: {
          authorization: process.env.FAST2SMS_API_KEY,
          'Content-Type': 'application/json',
        },
        timeout: 10000,
      }
    );

    console.log(`📱 Fast2SMS reset OTP response for ${cleanMobile}:`, smsRes.data);
    if (!smsRes.data.return) {
      console.error('Fast2SMS reset OTP error:', smsRes.data);
      return res.status(500).json({
        success: false,
        error: 'SMS sending failed. Check FAST2SMS_API_KEY in Render env vars.',
      });
    }

    res.json({
      success: true,
      message: `Password reset OTP sent to ${cleanMobile}`,
    });
  } catch (err) {
    console.error('sendResetOtp error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Reset Password ──────────────────────────────────────
exports.resetPassword = async (req, res) => {
  try {
    const { mobile, otp, password } = req.body;

    if (!mobile || !otp || !password) {
      return res.status(400).json({
        success: false,
        error: 'Mobile, OTP, and password are required',
      });
    }

    const cleanMobile = mobile.replace(/\D/g, '').replace(/^91/, '');
    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters',
      });
    }

    const user = await User.findOne({ mobile: cleanMobile });
    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found',
      });
    }

    if (user.otp !== otp) {
      return res.status(400).json({
        success: false,
        error: 'Invalid OTP. Please try again.',
      });
    }

    if (user.otpExpiry < new Date()) {
      return res.status(400).json({
        success: false,
        error: 'OTP expired. Please request a new one.',
      });
    }

    user.password = await hashPassword(password);
    user.otp = undefined;
    user.otpExpiry = undefined;
    await user.save();

    res.json({
      success: true,
      message: 'Password reset successful',
    });
  } catch (err) {
    console.error('resetPassword error:', err.message);
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

    const cleanMobile = mobile.replace(/\D/g, '').replace(/^91/, '');

    const user = await User.findOne({ mobile: cleanMobile });

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found. Please send OTP first.',
      });
    }

    if (user.otp !== otp) {
      return res.status(400).json({
        success: false,
        error: 'Invalid OTP. Please try again.',
      });
    }

    if (user.otpExpiry < new Date()) {
      return res.status(400).json({
        success: false,
        error: 'OTP expired. Please request a new one.',
      });
    }

    // Clear OTP after successful verification
    user.otp       = undefined;
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
    const allowed = [
      'name', 'shopName', 'address', 'city',
      'upiId', 'gstin', 'fcmToken',
    ];
    const updateData = {};
    allowed.forEach((field) => {
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

// Retrieve all vendors (shops)
exports.getAllVendors = async (req, res) => {
  try {
    const vendors = await User.find({ role: 'owner' })
      .select('name shopName address city mobile gstin upiId');
    res.json({ success: true, vendors });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// Reset Password with Recovery PIN
exports.resetPasswordWithPin = async (req, res) => {
  try {
    const { mobile, recoveryPin, newPassword } = req.body;
    if (!mobile || !recoveryPin || !newPassword) {
      return res.status(400).json({ success: false, error: 'Mobile, Recovery PIN and new password are required' });
    }
    const cleanMobile = normalizeMobile(mobile);
    const user = await User.findOne({ mobile: cleanMobile });
    if (!user) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }
    if (!user.recoveryPin || user.recoveryPin !== recoveryPin) {
      return res.status(400).json({ success: false, error: 'Invalid Recovery PIN' });
    }
    if (newPassword.length < 6) {
      return res.status(400).json({ success: false, error: 'Password must be at least 6 characters' });
    }
    user.password = await hashPassword(newPassword);
    await user.save();
    res.json({ success: true, message: 'Password reset successful' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};