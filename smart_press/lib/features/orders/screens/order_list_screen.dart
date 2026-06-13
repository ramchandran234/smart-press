// lib/features/orders/screens/order_list_screen.dart
// PPT Screen 7 — Order List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _typeFilter = 'All';
  final List<String> _types = ['All', 'Walk-in', 'Pickup', 'Delivery'];

  final List<Map<String, dynamic>> _orders = [
    {'id': 'ORD001', 'name': 'Priya Sharma', 'type': 'Pickup',
      'status': 'Washing', 'amount': '₹240', 'date': '05 May',
      'items': 5, 'color': AppColors.orange},
    {'id': 'ORD002', 'name': 'Raj Kumar', 'type': 'Walk-in',
      'status': 'Ready', 'amount': '₹180', 'date': '05 May',
      'items': 3, 'color': AppColors.green},
    {'id': 'ORD003', 'name': 'Anita Singh', 'type': 'Delivery',
      'status': 'Received', 'amount': '₹320', 'date': '04 May',
      'items': 7, 'color': AppColors.accent},
    {'id': 'ORD004', 'name': 'Suresh Babu', 'type': 'Pickup',
      'status': 'Delivered', 'amount': '₹560', 'date': '04 May',
      'items': 10, 'color': AppColors.textSub},
    {'id': 'ORD005', 'name': 'Deepa Nair', 'type': 'Walk-in',
      'status': 'Ironing', 'amount': '₹150', 'date': '03 May',
      'items': 4, 'color': AppColors.accent2},
    {'id': 'ORD006', 'name': 'Kiran Patel', 'type': 'Delivery',
      'status': 'Ready', 'amount': '₹420', 'date': '03 May',
      'items': 8, 'color': AppColors.green},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    return _orders.where((o) {
      if (_typeFilter != 'All' && o['type'] != _typeFilter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Done'),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Type filter chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _types.map((t) {
                  final selected = _typeFilter == t;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _typeFilter = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent
                            : AppColors.bgLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selected
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Text(t,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? AppColors.white
                                  : AppColors.textSub)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Order count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text('${_filtered.length} orders found',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSub)),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_filtered),
                _buildList(_filtered
                    .where((o) => o['status'] != 'Delivered')
                    .toList()),
                _buildList(_filtered
                    .where((o) => o['status'] == 'Delivered')
                    .toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/orders/new'),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('New Order',
            style: TextStyle(color: AppColors.white,
                fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _bottomNav(context, 1),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: AppColors.cardBorder),
            SizedBox(height: 12),
            Text('No orders found',
                style: TextStyle(color: AppColors.textSub)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: list.length,
      itemBuilder: (_, i) => _orderCard(list[i]),
    );
  }

  Widget _orderCard(Map<String, dynamic> o) {
    final color = o['color'] as Color;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/orders/${o['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_typeIcon(o['type']),
                    color: color, size: 22),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Text(o['id'],
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSub)),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                            color: AppColors.cardBorder,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text('${o['items']} items',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSub)),
                    ]),
                    const SizedBox(height: 3),
                    Text(o['date'],
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSub)),
                  ],
                ),
              ),
              // Right side
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(o['amount'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(o['status'],
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'Pickup': return Icons.local_shipping_outlined;
      case 'Delivery': return Icons.delivery_dining;
      default: return Icons.store_outlined;
    }
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
            icon: Icon(Icons.receipt_long), label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline), label: 'Customers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: 'Reports'),
      ],
      onTap: (i) {
        const routes = ['/home', '/orders',
            '/customers', '/reports/revenue'];
        context.go(routes[i]);
      },
    );
  }
}