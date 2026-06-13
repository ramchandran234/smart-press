// src/routes/expense.routes.js
const express = require('express');
const router  = express.Router();
const ctrl    = require('../controllers/expense.controller');
const {
  protect, ownerOnly
} = require('../middleware/auth.middleware');

router.use(protect, ownerOnly);

router.get('/',  ctrl.getAllExpenses);
router.post('/', ctrl.createExpense);

module.exports = router;