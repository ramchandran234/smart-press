// lib/features/logistics/screens/delivery_list_screen.dart
// PPT Screen 15 — Delivery List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class DeliveryListScreen extends StatefulWidget {
  const DeliveryListScreen({super.key});

  @override
  State<DeliveryListScreen> createState() =>
      _DeliveryListScreenState();
}

class _DeliveryListScreenState
    extends State<DeliveryListScreen> {
  final _deliveries = [
    {'name': 'Anita Mehta', 'address': 'HSR Layout Sector 7',
      'time': '4:00 PM', 'amount': '₹340', 'paid': true,
      'status': 'Pending', 'orderId': 'ORD006'},
    {'name': 'Suresh Babu', 'address': 'BTM Layout Stage 2',
      'time': '5:30 PM', 'amount': '₹220', 'paid': false,
      'status': 'Pending', 'orderId': 'ORD007'},
    {'name': 'Kavitha R', 'address': 'Banashankari 3rd Stage',
      'time': '6:00 PM', 'amount': '₹460', 'paid': true,
      'status': 'Delivered', 'orderId': 'ORD008'},
    {'name': 'Mohan Das', 'address': 'JP Nagar 6th Phase',
      'time': '7:00 PM', 'amount': '₹180', 'paid': false,
      'status': 'Pending', 'orderId': 'ORD009'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/schedule-slot'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _stat('Total', '${_deliveries.length}',
                    AppColors.accent),
                _stat(
                    'Pending',
                    '${_deliveries.where((d) => d['status'] == 'Pending').length}',
                    AppColors.orange),
                _stat(
                    'Delivered',
                    '${_deliveries.where((d) => d['status'] == 'Delivered').length}',
                    AppColors.green),
                _stat(
                    'Unpaid',
                    '${_deliveries.where((d) => d['paid'] == false).length}',
                    AppColors.red),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _deliveries.length,
              itemBuilder: (_, i) {
                final d = _deliveries[i];
                final delivered =
                    d['status'] == 'Delivered';
                final paid = d['paid'] as bool;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.green
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.delivery_dining,
                                  color: AppColors.green,
                                  size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(d['name'] as String,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 15)),
                                  Text(
                                      d['address'] as String,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors
                                              .textSub)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                Text(d['amount'] as String,
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2),
                                  decoration: BoxDecoration(
                                    color: paid
                                        ? AppColors.green
                                            .withOpacity(0.12)
                                        : AppColors.red
                                            .withOpacity(0.12),
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: Text(
                                      paid ? 'Paid' : 'Unpaid',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight.bold,
                                          color: paid
                                              ? AppColors.green
                                              : AppColors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14,
                                color: AppColors.textSub),
                            const SizedBox(width: 4),
                            Text(d['time'] as String,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.green,
                                    fontWeight:
                                        FontWeight.bold)),
                            const Spacer(),
                            // Call
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call,
                                  color: AppColors.green,
                                  size: 20),
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(),
                            ),
                            const SizedBox(width: 10),
                            // Navigate
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  Icons.navigation_outlined,
                                  color: AppColors.accent2,
                                  size: 20),
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(),
                            ),
                            const SizedBox(width: 10),
                            // Collect payment
                            if (!paid)
                              ElevatedButton(
                                onPressed: () => context
                                    .push('/collect-payment'),
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.gold,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6),
                                  minimumSize: Size.zero,
                                  textStyle: const TextStyle(
                                      fontSize: 11),
                                ),
                                child: const Text('Collect'),
                              ),
                            if (!delivered) ...[
                              const SizedBox(width: 6),
                              ElevatedButton(
                                onPressed: () => setState(() =>
                                    d['status'] = 'Delivered'),
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.green,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6),
                                  minimumSize: Size.zero,
                                  textStyle: const TextStyle(
                                      fontSize: 11),
                                ),
                                child: const Text('Delivered'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSub)),
      ],
    );
  }
}