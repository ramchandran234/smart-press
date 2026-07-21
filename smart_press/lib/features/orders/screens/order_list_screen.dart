// lib/features/orders/screens/order_list_screen.dart
// PPT Screen 7 — Order List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

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

  List<dynamic> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    try {
      final res = await OrderService.getOrders();
      if (res['success'] == true) {
        if (mounted) {
          setState(() {
            _orders = res['orders'] as List<dynamic>;
            _loading = false;
          });
        }
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> get _filtered {
    return _orders.where((o) {
      if (_typeFilter == 'All') return true;
      final type = o['orderType'] as String? ?? 'walk-in';
      return type.toLowerCase() == _typeFilter.toLowerCase();
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'received': return AppColors.accent;
      case 'washing':
      case 'ironing': return AppColors.orange;
      case 'ready': return AppColors.green;
      case 'delivered': return AppColors.textSub;
      default: return AppColors.accent;
    }
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (e) {
      return '';
    }
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
      body: RefreshIndicator(
        onRefresh: _fetchOrders,
        child: Column(
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildList(_filtered),
                        _buildList(_filtered
                            .where((o) => o['status'] != 'delivered' && o['status'] != 'cancelled')
                            .toList()),
                        _buildList(_filtered
                            .where((o) => o['status'] == 'delivered')
                            .toList()),
                      ],
                    ),
            ),
          ],
        ),
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

  Widget _buildList(List<dynamic> list) {
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
    final status = o['status'] as String? ?? 'received';
    final color = _getStatusColor(status);
    final cust = o['customer'] as Map<String, dynamic>?;
    final custName = cust != null ? cust['name'] as String? ?? 'Walk-in' : 'Walk-in';
    final itemsCount = (o['garments'] as List?)?.fold<int>(0, (sum, item) => sum + (item['qty'] as int? ?? 0)) ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/orders/${o['_id']}'),
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
                child: Icon(_typeIcon(o['orderType'] as String? ?? 'walk-in'),
                    color: color, size: 22),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(custName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Text(o['orderId'] as String? ?? '',
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
                      Text('$itemsCount items',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSub)),
                    ]),
                    const SizedBox(height: 3),
                    Text(_formatDate(o['createdAt'] as String? ?? ''),
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
                  Text('₹${(o['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
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
                    child: Text(status,
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
      case 'pickup': return Icons.local_shipping_outlined;
      case 'delivery': return Icons.delivery_dining;
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