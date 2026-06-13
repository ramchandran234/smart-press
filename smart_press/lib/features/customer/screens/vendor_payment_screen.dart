// lib/features/customer/screens/vendor_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class VendorPaymentScreen extends StatefulWidget {
  const VendorPaymentScreen({super.key});

  @override
  State<VendorPaymentScreen> createState() =>
      _VendorPaymentScreenState();
}

class _VendorPaymentScreenState
    extends State<VendorPaymentScreen> {
  String _mode = 'UPI';
  final _modes = ['UPI', 'Cash', 'Card'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Pay Vendor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Vendor + amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.darkBg,
                    AppColors.accent2
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store,
                          color: Colors.white70, size: 18),
                      SizedBox(width: 6),
                      Text('Smart Press',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('₹ 240',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Vendor Order — ORD001',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Payment Mode',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            const SizedBox(height: 12),

            Row(
              children: _modes.map((m) {
                final sel = _mode == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _mode = m),
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.orange
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                            color: sel
                                ? AppColors.orange
                                : AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            m == 'UPI'
                                ? Icons.qr_code
                                : m == 'Cash'
                                    ? Icons.money
                                    : Icons.credit_card,
                            color: sel
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 26,
                          ),
                          const SizedBox(height: 4),
                          Text(m,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 12,
                                  color: sel
                                      ? AppColors.white
                                      : AppColors.textSub)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (_mode == 'UPI') ...[
              const SizedBox(height: 24),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.cardBorder, width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10)
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.qr_code,
                      size: 130, color: AppColors.darkBg),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Scan vendor QR to pay',
                  style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 12)),
            ],

            const Spacer(),
            AppButton(
              label: 'Confirm Payment — ₹240',
              color: AppColors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment successful!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.go('/customer/dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }
}