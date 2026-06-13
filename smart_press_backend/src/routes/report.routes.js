// src/routes/report.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/report.controller');
const {
  protect, ownerOnly
} = require('../middleware/auth.middleware');

router.use(protect, ownerOnly);

router.get('/revenue',     ctrl.getRevenue);
router.get('/profit',      ctrl.getProfit);
router.get('/receivables', ctrl.getReceivables);

module.exports = router;