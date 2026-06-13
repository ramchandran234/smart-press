// src/routes/customer.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/customer.controller');
const {
  protect, ownerOnly
} = require('../middleware/auth.middleware');

router.use(protect, ownerOnly);

router.get('/',              ctrl.getAllCustomers);
router.post('/',             ctrl.createCustomer);
router.get('/:id',           ctrl.getCustomerById);
router.put('/:id',           ctrl.updateCustomer);
router.get('/:id/orders',    ctrl.getCustomerOrders);

module.exports = router;