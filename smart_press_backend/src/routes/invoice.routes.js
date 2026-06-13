// src/routes/invoice.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/invoice.controller');
const {
  protect, ownerOnly
} = require('../middleware/auth.middleware');

router.use(protect);

router.get('/',              ownerOnly, ctrl.getAllInvoices);
router.get('/:id',           ctrl.getInvoiceById);
router.post('/:id/share',    ctrl.shareInvoice);

module.exports = router;