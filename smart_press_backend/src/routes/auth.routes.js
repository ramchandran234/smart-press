// src/routes/auth.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/auth.controller');
const { protect } = require('../middleware/auth.middleware');

// Public routes
router.post('/register',           ctrl.register);
router.post('/login',              ctrl.login);
router.post('/send-otp',           ctrl.sendOtp);
router.post('/verify-otp',         ctrl.verifyOtp);
router.post('/send-reset-otp',     ctrl.sendResetOtp);
router.post('/reset-password',     ctrl.resetPassword);
router.post('/reset-password-pin', ctrl.resetPasswordWithPin);

// Protected routes
router.get('/profile',             protect, ctrl.getProfile);
router.put('/profile',      protect, ctrl.updateProfile);
router.get('/vendors',             protect, ctrl.getAllVendors);

module.exports = router;