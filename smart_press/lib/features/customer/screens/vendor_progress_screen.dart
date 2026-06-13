// lib/features/customer/screens/vendor_progress_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class VendorProgressScreen extends StatelessWidget {
  final String orderId;
  const VendorProgressScreen(
      {super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Order Placed', 'done': true,
        'time': '9:00 AM', 'icon': Icons.receipt},
      {'label': 'Vendor Accepted', 'done': true,
        'time': '9:15 AM', 'icon': Icons.store},
      {'label': 'Picked Up', 'done': true,
        'time': '10:30 AM',
        'icon': Icons.local_shipping},
      {'label': 'Ironing in Progress', 'done': false,
        'time': 'Pending', 'icon': Icons.iron},
      {'label': 'Ready for Delivery', 'done': false,
        'time': 'Pending',
        'icon': Icons.check_circle_outline},
      {'label': 'Delivered', 'done': false,
        'time': 'Pending', 'icon': Icons.done_all},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text('Vendor Order — $orderId'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.orange,
                    AppColors.gold
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.store,
                          color: AppColors.white,
                          size: 20),
                      SizedBox(width: 8),
                      Text('Smart Press',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('🔥 Ironing in Progress',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor:
                          Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation(
                              AppColors.white),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Step 4 of 6  •  60% done',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Progress Timeline',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 16),

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
                              ? AppColors.orange
                              : AppColors.cardBorder,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            step['icon'] as IconData,
                            color: done
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 20),
                      ),
                      if (!isLast)
                        Container(
                            width: 2,
                            height: 40,
                            color: done
                                ? AppColors.orange
                                : AppColors.cardBorder),
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
                                      ? AppColors.orange
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
                          color: AppColors.orange,
                          size: 18),
                    ),
                ],
              );
            }),
            const SizedBox(height: 20),

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
                  _row('Order ID', orderId),
                  _row('Vendor', 'Smart Press'),
                  _row('Service', 'Wash + Iron'),
                  _row('Items', '5 garments'),
                  _row('Est. Ready', '07 May, 4PM'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSub, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}