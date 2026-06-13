// src/routes/auth.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/auth.controller');
const { protect } = require('../middleware/auth.middleware');

// Public routes
router.post('/send-otp',    ctrl.sendOtp);
router.post('/verify-otp',  ctrl.verifyOtp);

// Protected routes
router.get('/profile',      protect, ctrl.getProfile);
router.put('/profile',      protect, ctrl.updateProfile);

module.exports = router;