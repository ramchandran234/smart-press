// lib/features/invoices/screens/invoice_view_screen.dart
// PPT Screen 23 — Invoice View Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class InvoiceViewScreen extends StatelessWidget {
  final String invoiceId;
  const InvoiceViewScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice #$invoiceId'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () =>
                  context.push('/invoices/$invoiceId/share')),
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Invoice card
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.darkBg,
                          AppColors.accent2
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('SMART PRESS',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1)),
                                Text(
                                    'Professional Laundry Services',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 11)),
                              ],
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: const Text('PAID',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Bill To:',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 11)),
                                Text('Priya Sharma',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight:
                                            FontWeight.bold)),
                                Text('+91 98765 43210',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Invoice #$invoiceId',
                                    style: const TextStyle(
                                        color: AppColors.gold,
                                        fontWeight:
                                            FontWeight.bold)),
                                const Text('05 May 2026',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Garments table
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Table header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        AppColors.cardBorder)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                  child: Text('Item',
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors
                                              .textSub))),
                              SizedBox(
                                  width: 40,
                                  child: Text('Qty',
                                      textAlign:
                                          TextAlign.center,
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors
                                              .textSub))),
                              SizedBox(
                                  width: 50,
                                  child: Text('Rate',
                                      textAlign:
                                          TextAlign.right,
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors
                                              .textSub))),
                              SizedBox(
                                  width: 60,
                                  child: Text('Total',
                                      textAlign:
                                          TextAlign.right,
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors
                                              .textSub))),
                            ],
                          ),
                        ),
                        _invoiceRow('Shirt', 2, 40),
                        _invoiceRow('Trouser', 1, 50),
                        _invoiceRow('Saree', 2, 80),
                        const Divider(),
                        _totalLine('Subtotal', '₹290'),
                        _totalLine('Delivery Charge', '₹40'),
                        _totalLine('Discount', '-₹0'),
                        const Divider(),
                        _totalLine('Grand Total', '₹330',
                            bold: true, color: AppColors.accent2),
                      ],
                    ),
                  ),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.highlight,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: const Column(
                      children: [
                        Text('Thank you for choosing Smart Press!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent2)),
                        SizedBox(height: 4),
                        Text(
                            'For support: +91 98765 00000  •  smartpress.in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Share Invoice',
              onTap: () => context
                  .push('/invoices/$invoiceId/share'),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Download PDF',
              onTap: () {},
              color: AppColors.accent2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceRow(String name, int qty, int rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(name,
              style: const TextStyle(fontSize: 13))),
          SizedBox(
              width: 40,
              child: Text('x$qty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSub))),
          SizedBox(
              width: 50,
              child: Text('₹$rate',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSub))),
          SizedBox(
              width: 60,
              child: Text('₹${qty * rate}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13))),
        ],
      ),
    );
  }

  Widget _totalLine(String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 15 : 13,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: bold
                      ? AppColors.textDark
                      : AppColors.textSub)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 18 : 13,
                  fontWeight: FontWeight.bold,
                  color: color ?? AppColors.textDark)),
        ],
      ),
    );
  }
}