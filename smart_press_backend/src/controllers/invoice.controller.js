// src/controllers/invoice.controller.js
const Invoice = require('../models/Invoice');

exports.getAllInvoices = async (req, res) => {
  try {
    const { isPaid, page = 1, limit = 20 } = req.query;
    const filter = { owner: req.user.id };
    if (isPaid !== undefined) {
      filter.isPaid = isPaid === 'true';
    }

    const invoices = await Invoice.find(filter)
      .populate('customer', 'name mobile')
      .populate('order', 'orderId orderType')
      .sort({ createdAt: -1 })
      .limit(Number(limit))
      .skip((Number(page) - 1) * Number(limit));

    res.json({ success: true, invoices });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.getInvoiceById = async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id)
      .populate('customer', 'name mobile address')
      .populate('order');

    if (!invoice) {
      return res.status(404).json({
        success: false,
        error: 'Invoice not found',
      });
    }
    res.json({ success: true, invoice });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};

exports.shareInvoice = async (req, res) => {
  try {
    const { via } = req.body; // 'whatsapp', 'sms', 'email'
    await Invoice.findByIdAndUpdate(req.params.id, {
      $addToSet: { sharedVia: via }
    });
    // TODO: Implement actual sharing via Twilio/SendGrid
    res.json({
      success: true,
      message: `Invoice shared via ${via}`,
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};