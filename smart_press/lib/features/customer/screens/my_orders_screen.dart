// lib/features/customer/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class CustomerMyOrdersScreen extends StatefulWidget {
  const CustomerMyOrdersScreen({super.key});

  @override
  State<CustomerMyOrdersScreen> createState() =>
      _CustomerMyOrdersScreenState();
}

class _CustomerMyOrdersScreenState
    extends State<CustomerMyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _orders = [
    {'id': 'ORD001', 'shop': 'Smart Press',
      'status': 'Washing', 'items': 5,
      'amount': '₹240', 'date': '05 May',
      'color': AppColors.orange, 'active': true},
    {'id': 'ORD091', 'shop': 'Smart Press',
      'status': 'Ready', 'items': 3,
      'amount': '₹180', 'date': '04 May',
      'color': AppColors.green, 'active': true},
    {'id': 'ORD082', 'shop': 'Smart Press',
      'status': 'Delivered', 'items': 8,
      'amount': '₹480', 'date': '28 Apr',
      'color': AppColors.textSub, 'active': false},
    {'id': 'ORD074', 'shop': 'Smart Press',
      'status': 'Delivered', 'items': 4,
      'amount': '₹220', 'date': '15 Apr',
      'color': AppColors.textSub, 'active': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_orders
              .where((o) => o['active'] == true)
              .toList()),
          _buildList(_orders
              .where((o) => o['active'] == false)
              .toList()),
        ],
      ),
      bottomNavigationBar: _bottomNav(context, 1),
    );
  }

  Widget _buildList(List list) {
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: AppColors.cardBorder),
            SizedBox(height: 12),
            Text('No orders here',
                style: TextStyle(color: AppColors.textSub)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final o = list[i] as Map<String, dynamic>;
        final color = o['color'] as Color;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(
                '/customer/order-detail/${o['id']}'),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            Icons.local_laundry_service,
                            color: color,
                            size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(o['shop'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text(
                                '${o['id']}  •  ${o['date']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSub)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(o['amount'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Text(o['status'] as String,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: color,
                                    fontWeight:
                                        FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (o['active'] == true) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: o['status'] == 'Washing'
                            ? 0.4
                            : 0.8,
                        backgroundColor: AppColors.cardBorder,
                        valueColor:
                            AlwaysStoppedAnimation(color),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status: ${o['status']}',
                            style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () => context.push(
                              '/customer/order-progress/${o['id']}'),
                          child: const Text('Track →',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.accent,
                                  fontWeight:
                                      FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomNav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'Vendors'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile'),
      ],
      onTap: (i) {
        const routes = [
          '/customer/dashboard',
          '/customer/orders',
          '/customer/vendors',
          '/customer/settings',
        ];
        context.go(routes[i]);
      },
    );
  }
}