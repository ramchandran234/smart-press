// src/routes/supplier.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/supplier.controller');
const {
  protect, ownerOnly
} = require('../middleware/auth.middleware');

router.use(protect, ownerOnly);

router.get('/',            ctrl.getAllSuppliers);
router.post('/',           ctrl.createSupplier);
router.get('/:id',         ctrl.getSupplierById);
router.post('/:id/pay',    ctrl.recordPayment);

module.exports = router;