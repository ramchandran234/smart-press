// lib/features/payments/screens/collect_payment_screen.dart
// PPT Screen 21 — Collect Payment Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class CollectPaymentScreen extends StatefulWidget {
  const CollectPaymentScreen({super.key});

  @override
  State<CollectPaymentScreen> createState() =>
      _CollectPaymentScreenState();
}

class _CollectPaymentScreenState
    extends State<CollectPaymentScreen> {
  String _mode = 'QR';
  final _cashController = TextEditingController();
  double _received = 0;
  final double _total = 340;

  double get _change =>
      _received > _total ? _received - _total : 0;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collect Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkBg, AppColors.accent2],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order: ORD001',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                      Text('Priya Sharma',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('₹ 340',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Amount Due',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment mode toggle
            const Text('Payment Mode',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: ['QR', 'Cash'].map((m) {
                final sel = _mode == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _mode = m),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.accent
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            m == 'QR'
                                ? Icons.qr_code
                                : Icons.money,
                            color: sel
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m == 'QR'
                                ? 'QR / UPI'
                                : 'Cash',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sel
                                    ? AppColors.white
                                    : AppColors.textSub),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // QR mode
            if (_mode == 'QR') ...[
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.cardBorder,
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.qr_code,
                            size: 140,
                            color: AppColors.darkBg),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                        'Ask customer to scan this QR',
                        style: TextStyle(
                            color: AppColors.textSub,
                            fontSize: 13)),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: () =>
                          context.push('/owner-qr'),
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('Full Screen QR'),
                    ),
                  ],
                ),
              ),
            ],

            // Cash mode
            if (_mode == 'Cash') ...[
              const Text('Cash Received (₹)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _cashController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  prefixText: '₹  ',
                  hintText: '0',
                ),
                onChanged: (v) => setState(
                    () => _received = double.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 16),
              if (_received > 0) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _change > 0
                        ? AppColors.green.withOpacity(0.1)
                        : AppColors.highlight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _change > 0
                            ? AppColors.green
                                .withOpacity(0.3)
                            : AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Amount Due',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSub)),
                          Text('₹${_total.toInt()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                              _change > 0
                                  ? 'Change to Return'
                                  : 'Balance',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSub)),
                          Text(
                              _change > 0
                                  ? '₹${_change.toInt()}'
                                  : '₹${(_total - _received).toInt()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _change > 0
                                      ? AppColors.green
                                      : AppColors.red)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 24),

            AppButton(
              label: 'Record Payment & Print Receipt',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment recorded!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.pop();
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Share Receipt via WhatsApp',
              onTap: () {},
              color: AppColors.green,
            ),
          ],
        ),
      ),
    );
  }
}