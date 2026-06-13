// src/middleware/auth.middleware.js
const jwt  = require('jsonwebtoken');
const User = require('../models/User');

// Protect — verify JWT token
exports.protect = async (req, res, next) => {
  try {
    let token;

    if (req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Not authorized — no token',
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = await User.findById(decoded.id).select('-otp -otpExpiry');

    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'User not found',
      });
    }

    next();
  } catch (err) {
    res.status(401).json({
      success: false,
      error: 'Token invalid or expired',
    });
  }
};

// Owner only
exports.ownerOnly = (req, res, next) => {
  if (req.user.role !== 'owner') {
    return res.status(403).json({
      success: false,
      error: 'Owner access only',
    });
  }
  next();
};

// Customer only
exports.customerOnly = (req, res, next) => {
  if (req.user.role !== 'customer') {
    return res.status(403).json({
      success: false,
      error: 'Customer access only',
    });
  }
  next();
};