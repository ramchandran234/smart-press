// src/routes/order.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/order.controller');
const {
  protect, ownerOnly, customerOnly
} = require('../middleware/auth.middleware');

router.use(protect);

router.get('/',              ownerOnly, ctrl.getAllOrders);
router.post('/',             ownerOnly, ctrl.createOrder);
router.get('/history',       ownerOnly, ctrl.getOrderHistory);
router.get('/customer-app',  ctrl.getCustomerOrdersForApp);
router.post('/customer-app', customerOnly, ctrl.customerCreateOrder);
router.get('/:id',           ctrl.getOrderById);
router.put('/:id/status',    ownerOnly, ctrl.updateStatus);
router.post('/:id/payment',  ownerOnly, ctrl.collectPayment);

module.exports = router;