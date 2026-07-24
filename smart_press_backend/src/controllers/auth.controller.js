// src/controllers/auth.controller.js
const User          = require('../models/User');
const generateToken = require('../utils/generateToken');
const axios         = require('axios'); // npm install axios
const mongoose      = require('mongoose');
const memoryDb      = require('../utils/memoryDb');
const { normalizeMobile, hashPassword, comparePassword } = require('../utils/authUtils');
const nodemailer    = require('nodemailer');

// Setup Ethereal mock email transporter
const transporter = nodemailer.createTransport({
  host: 'smtp.ethereal.email',
  port: 587,
  auth: {
    user: 'laundry.mock@ethereal.email', // Replace with real credentials in production
    pass: 'dummy-password'
  }
});

exports.register = async (req, res) => {
  try {
    const { name, mobile, email, password, role, shopName, addressLine1, area, city, latitude, longitude, isOpen } = req.body;

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

    const hashedPassword = await hashPassword(password);
    let user;

    try {
      const existingUser = await User.findOne({ mobile: cleanMobile });
      if (existingUser) {
        return res.status(409).json({
          success: false,
          error: 'User already exists with this mobile number',
        });
      }

      user = await User.create({
        name,
        mobile: cleanMobile,
        email,
        password: hashedPassword,
        role: role || 'customer',
        isVerified: true,
        shopName,
        addressLine1,
        area,
        city,
        address: addressLine1 || req.body.address,
        latitude: latitude != null ? Number(latitude) : undefined,
        longitude: longitude != null ? Number(longitude) : undefined,
        isOpen: isOpen != null ? Boolean(isOpen) : true,
      });
    } catch (dbErr) {
      console.warn('⚠️ MongoDB write unavailable, using memoryDb fallback:', dbErr.message);
      const existingUser = memoryDb.findUserByMobile(cleanMobile);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          error: 'User already exists with this mobile number',
        });
      }

      user = memoryDb.createUser({
        name,
        mobile: cleanMobile,
        email,
        password: hashedPassword,
        role: role || 'customer',
        isVerified: true,
        shopName,
        addressLine1,
        area,
        city,
        address: addressLine1 || req.body.address,
        latitude: latitude != null ? Number(latitude) : undefined,
        longitude: longitude != null ? Number(longitude) : undefined,
        isOpen: isOpen != null ? Boolean(isOpen) : true,
      });
    }

    const token = generateToken(user._id, user.role);
    res.status(201).json({
      success: true,
      message: 'Registration successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        mobile: user.mobile,
        email: user.email,
        role: user.role,
        shopName: user.shopName,
        addressLine1: user.addressLine1,
        area: user.area,
        city: user.city,
        address: user.address,
        latitude: user.latitude,
        longitude: user.longitude,
        isOpen: user.isOpen != null ? user.isOpen : true,
        isVerified: user.isVerified,
      },
    });
  } catch (err) {
    console.error('register error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.login = async (req, res) => {
  try {
    const input = req.body.username || req.body.mobile || req.body.name;
    const { password, role } = req.body;

    if (!input || !password) {
      return res.status(400).json({
        success: false,
        error: 'Username and password are required',
      });
    }

    const cleanInput = input.trim();
    const cleanMobile = normalizeMobile(cleanInput);
    let user;

    if (mongoose.connection.readyState === 1) {
      user = await User.findOne({
        $or: [
          { mobile: cleanMobile },
          { name: new RegExp(`^${cleanInput}$`, 'i') },
          { shopName: new RegExp(`^${cleanInput}$`, 'i') },
        ]
      });
    } else {
      user = memoryDb.users.find(u =>
        u.mobile === cleanMobile ||
        u.mobile === cleanInput ||
        (u.name && u.name.toLowerCase() === cleanInput.toLowerCase()) ||
        (u.shopName && u.shopName.toLowerCase() === cleanInput.toLowerCase())
      );
    }

    if (!user || !user.password) {
      return res.status(401).json({
        success: false,
        error: 'Invalid username or password',
      });
    }

    const isMatch = await comparePassword(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        error: 'Invalid username or password',
      });
    }

    if (role && user.role && user.role !== role) {
      const targetRole = user.role === 'customer' ? 'Customer' : 'Owner';
      return res.status(400).json({
        success: false,
        error: `This account is registered as ${targetRole}. Please use ${targetRole} Login.`,
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
        email: user.email,
        role: user.role,
        shopName: user.shopName,
        addressLine1: user.addressLine1,
        area: user.area,
        city: user.city,
        address: user.address,
        latitude: user.latitude,
        longitude: user.longitude,
        isOpen: user.isOpen != null ? user.isOpen : true,
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
    if (mongoose.connection.readyState === 1) {
      await User.findOneAndUpdate(
        { mobile: cleanMobile },
        { otp, otpExpiry, role: role || 'customer' },
        { upsert: true, new: true, setDefaultsOnInsert: true }
      );
    } else {
      let user = memoryDb.findUserByMobile(cleanMobile);
      if (user) {
        memoryDb.updateUser(cleanMobile, { otp, otpExpiry, role: role || 'customer' });
      } else {
        memoryDb.createUser({ mobile: cleanMobile, otp, otpExpiry, role: role || 'customer' });
      }
    }

    // Attempt Fast2SMS dispatch if API key is present
    if (process.env.FAST2SMS_API_KEY) {
      try {
        const smsRes = await axios.post(
          'https://www.fast2sms.com/dev/bulkV2',
          {
            message:  `Your Smart Press OTP is ${otp}. Valid for 10 minutes.`,
            language: 'english',
            route:    'q',
            numbers:  cleanMobile,
          },
          {
            headers: {
              authorization:  process.env.FAST2SMS_API_KEY,
              'Content-Type': 'application/json',
            },
            timeout: 5000,
          }
        );
        console.log(`📱 Fast2SMS response for ${cleanMobile}:`, smsRes.data);
      } catch (smsErr) {
        console.warn('⚠️ Fast2SMS dispatch skipped/error:', smsErr.message);
      }
    }

    // Success — Return instant response
    res.json({
      success: true,
      message: `OTP sent to ${cleanMobile}`,
    });

  } catch (err) {
    console.error('sendOtp error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Send Password Reset OTP (Via Email) ─────────────────
exports.sendResetOtp = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        success: false,
        error: 'Email is required',
      });
    }

    const cleanEmail = email.trim().toLowerCase();
    
    let user;
    if (mongoose.connection.readyState === 1) {
      user = await User.findOne({ email: cleanEmail });
    } else {
      user = memoryDb.users.find(u => u.email === cleanEmail);
    }
    
    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found with this email address',
      });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

    user.otp = otp;
    user.otpExpiry = otpExpiry;
    if (mongoose.connection.readyState === 1) {
      await user.save();
    }

    // Send email using Nodemailer
    try {
      const info = await transporter.sendMail({
        from: '"Smart Press" <no-reply@smartpress.com>',
        to: cleanEmail,
        subject: 'Password Reset OTP',
        text: `Your Smart Press password reset OTP is ${otp}. Valid for 10 minutes.`,
        html: `<b>Your Smart Press password reset OTP is:</b> <h2>${otp}</h2><p>Valid for 10 minutes.</p>`
      });
      console.log(`✉️ Email sent to ${cleanEmail}:`, nodemailer.getTestMessageUrl(info) || info.messageId);
    } catch (emailErr) {
      console.error('Email sending failed:', emailErr.message);
      // For development, we log the OTP if email fails
      console.log(`🛠️ [DEV MODE] OTP for ${cleanEmail} is ${otp}`);
    }

    res.json({
      success: true,
      message: `Password reset OTP sent to ${cleanEmail}`,
    });
  } catch (err) {
    console.error('sendResetOtp error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
};

// ── Reset Password ──────────────────────────────────────
exports.resetPassword = async (req, res) => {
  try {
    const { email, otp, password } = req.body;

    if (!email || !otp || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email, OTP, and password are required',
      });
    }

    const cleanEmail = email.trim().toLowerCase();
    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters',
      });
    }

    let user;
    if (mongoose.connection.readyState === 1) {
      user = await User.findOne({ email: cleanEmail });
    } else {
      user = memoryDb.users.find(u => u.email === cleanEmail);
    }
    
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
    if (mongoose.connection.readyState === 1) {
      await user.save();
    }

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
        latitude:   user.latitude,
        longitude:  user.longitude,
        isOpen:     user.isOpen != null ? user.isOpen : true,
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
      'name', 'shopName', 'address', 'addressLine1', 'area', 'city',
      'upiId', 'gstin', 'fcmToken', 'latitude', 'longitude', 'isOpen', 'email'
    ];
    const updateData = {};
    allowed.forEach((field) => {
      if (req.body[field] !== undefined) {
        updateData[field] = req.body[field];
      }
    });

    if (mongoose.connection.readyState === 1) {
      const user = await User.findByIdAndUpdate(
        req.user.id,
        updateData,
        { new: true, runValidators: true }
      ).select('-otp -otpExpiry -__v');
      return res.json({ success: true, user });
    }

    // In-memory fallback
    const user = memoryDb.findUserById(req.user.id);
    if (user) {
      Object.assign(user, updateData, { updatedAt: new Date() });
      return res.json({ success: true, user });
    }
    res.status(404).json({ success: false, error: 'User not found' });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

// Retrieve all vendors (shops)
exports.getAllVendors = async (req, res) => {
  try {
    if (mongoose.connection.readyState === 1) {
      const vendors = await User.find({ role: 'owner' })
        .select('name shopName address area city mobile gstin upiId latitude longitude isOpen');
      return res.json({ success: true, vendors });
    }

    // In-memory fallback
    const vendors = memoryDb.users.filter(u => u.role === 'owner');
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