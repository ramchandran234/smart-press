// lib/features/customers/screens/customer_orders_screen.dart
// PPT Screen 20 — Customer Order History Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class CustomerOrdersScreen extends StatefulWidget {
  final String customerId;
  const CustomerOrdersScreen(
      {super.key, required this.customerId});

  @override
  State<CustomerOrdersScreen> createState() =>
      _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState
    extends State<CustomerOrdersScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Paid', 'Unpaid', 'Cancelled'];

  final _orders = [
    {'id': 'ORD001', 'date': '05 May 2026',
      'items': 5, 'amount': '₹240',
      'status': 'Washing', 'paid': false,
      'color': AppColors.orange},
    {'id': 'ORD091', 'date': '28 Apr 2026',
      'items': 8, 'amount': '₹480',
      'status': 'Delivered', 'paid': true,
      'color': AppColors.green},
    {'id': 'ORD082', 'date': '15 Apr 2026',
      'items': 3, 'amount': '₹180',
      'status': 'Delivered', 'paid': true,
      'color': AppColors.green},
    {'id': 'ORD074', 'date': '01 Apr 2026',
      'items': 6, 'amount': '₹360',
      'status': 'Cancelled', 'paid': false,
      'color': AppColors.red},
    {'id': 'ORD065', 'date': '20 Mar 2026',
      'items': 4, 'amount': '₹220',
      'status': 'Delivered', 'paid': true,
      'color': AppColors.green},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _orders.where((o) {
      if (_filter == 'All') return true;
      if (_filter == 'Paid') return o['paid'] == true;
      if (_filter == 'Unpaid') return o['paid'] == false;
      if (_filter == 'Cancelled') {
        return o['status'] == 'Cancelled';
      }
      return true;
    }).cast<Map<String, dynamic>>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Downloading statement...'),
                    backgroundColor: AppColors.accent2),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Customer header
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.darkBg,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      AppColors.white.withOpacity(0.2),
                  child: const Text('P',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('Priya Sharma',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Text('12 orders  •  ₹4,820 total',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Filter chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final sel = _filter == f;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 180),
                      margin:
                          const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.accent
                            : AppColors.bgLight,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? AppColors.white
                                  : AppColors.textSub)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Orders list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final o = _filtered[i];
                final color = o['color'] as Color;
                final paid = o['paid'] as bool;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context
                        .push('/orders/${o['id']}'),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                color.withOpacity(0.12),
                            child: Icon(Icons.receipt_long,
                                color: color, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(o['id'] as String,
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold)),
                                Text(
                                    '${o['items']} items  •  ${o['date']}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color:
                                            AppColors.textSub)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(o['amount'] as String,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 15)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                    child: Text(
                                        o['status'] as String,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: color,
                                            fontWeight:
                                                FontWeight
                                                    .bold)),
                                  ),
                                  const SizedBox(width: 4),
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
                                        paid
                                            ? 'Paid'
                                            : 'Unpaid',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight:
                                                FontWeight.bold,
                                            color: paid
                                                ? AppColors
                                                    .green
                                                : AppColors
                                                    .red)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/new'),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('New Order',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}