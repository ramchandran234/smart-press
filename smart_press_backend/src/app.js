// src/app.js
const express = require('express');
const cors    = require('cors');
require('dotenv').config();

// Import routes
const authRoutes     = require('./routes/auth.routes');
const orderRoutes    = require('./routes/order.routes');
const customerRoutes = require('./routes/customer.routes');
const supplierRoutes = require('./routes/supplier.routes');
const expenseRoutes  = require('./routes/expense.routes');
const invoiceRoutes  = require('./routes/invoice.routes');
const reportRoutes   = require('./routes/report.routes');

const app = express();

// ── Middleware ──────────────────────────────────────────
app.use(cors());
app.use(express.json());
// Increase request timeout
app.use((req, res, next) => {
  res.setTimeout(60000, () => {
    res.status(408).json({
      success: false,
      error: 'Request timeout'
    });
  });
  next();
});
app.use(express.urlencoded({ extended: true }));

// ── Health check ────────────────────────────────────────
app.get(['/', '/health', '/api', '/api/health'], (req, res) => {
  res.json({
    status: '✅ Iron Buddy API Running',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// ── API Routes ──────────────────────────────────────────
app.use('/api/auth',      authRoutes);
app.use('/api/orders',    orderRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/suppliers', supplierRoutes);
app.use('/api/expenses',  expenseRoutes);
app.use('/api/invoices',  invoiceRoutes);
app.use('/api/reports',   reportRoutes);

// ── 404 Handler ─────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// ── Global Error Handler ─────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

module.exports = app;