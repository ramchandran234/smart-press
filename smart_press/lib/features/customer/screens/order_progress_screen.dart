// lib/features/customer/screens/order_progress_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CustomerOrderProgressScreen extends StatelessWidget {
  final String orderId;
  const CustomerOrderProgressScreen(
      {super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Order Received', 'done': true,
        'time': '9:00 AM', 'icon': Icons.inbox},
      {'label': 'Picked Up', 'done': true,
        'time': '10:30 AM', 'icon': Icons.local_shipping},
      {'label': 'Washing', 'done': true,
        'time': '11:00 AM',
        'icon': Icons.local_laundry_service},
      {'label': 'Ironing', 'done': false,
        'time': 'Pending', 'icon': Icons.iron},
      {'label': 'Ready', 'done': false,
        'time': 'Pending',
        'icon': Icons.check_circle_outline},
      {'label': 'Delivered', 'done': false,
        'time': 'Pending', 'icon': Icons.done_all},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text('Track — $orderId'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.accent2,
                    AppColors.accent
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text('Current Status',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12)),
                  const SizedBox(height: 6),
                  const Text('🫧 Washing in Progress',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor:
                          Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(
                              AppColors.gold),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step 3 of 6',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11)),
                      Text('50% Complete',
                          style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Order Timeline',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 16),

            // Timeline steps
            ...steps.asMap().entries.map((e) {
              final i = e.key;
              final step = e.value;
              final done = step['done'] as bool;
              final isLast = i == steps.length - 1;
              return Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.green
                              : AppColors.cardBorder,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step['icon'] as IconData,
                          color: done
                              ? AppColors.white
                              : AppColors.textSub,
                          size: 20,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: done
                              ? AppColors.green
                              : AppColors.cardBorder,
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(step['label'] as String,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 14,
                                  color: done
                                      ? AppColors.textDark
                                      : AppColors.textSub)),
                          Text(step['time'] as String,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: done
                                      ? AppColors.green
                                      : AppColors.textSub)),
                          if (!isLast)
                            const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  if (done)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Icon(Icons.check_circle,
                          color: AppColors.green,
                          size: 18),
                    ),
                ],
              );
            }),
            const SizedBox(height: 20),

            // Order info card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _infoRow('Order ID', orderId),
                  _infoRow('Shop', 'Smart Press'),
                  _infoRow('Items', '5 garments'),
                  _infoRow('Amount', '₹240'),
                  _infoRow(
                      'Est. Delivery', '07 May 2026'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}