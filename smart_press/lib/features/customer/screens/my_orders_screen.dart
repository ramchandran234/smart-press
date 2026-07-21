// lib/features/customer/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

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

  List<dynamic> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    try {
      final res = await OrderService.getCustomerAppOrders();
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
      body: RefreshIndicator(
        onRefresh: _fetchOrders,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildList(_orders
                      .where((o) => o['status'] != 'delivered' && o['status'] != 'cancelled')
                      .toList()),
                  _buildList(_orders
                      .where((o) => o['status'] == 'delivered' || o['status'] == 'cancelled')
                      .toList()),
                ],
              ),
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
        final status = o['status'] as String? ?? 'received';
        final color = _getStatusColor(status);
        final shop = o['owner'] as Map<String, dynamic>?;
        final shopName = shop != null ? shop['shopName'] as String? ?? 'Smart Press' : 'Smart Press';
        final active = status != 'delivered' && status != 'cancelled';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(
                '/customer/order-detail/${o['_id']}'),
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
                            Text(shopName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text(
                                '${o['orderId']}  •  ${_formatDate(o['createdAt'] as String? ?? '')}',
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
                          Text('₹${(o['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
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
                            child: Text(status,
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
                  if (active) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: status == 'washing'
                            ? 0.5
                            : (status == 'ironing' ? 0.75 : (status == 'ready' ? 0.9 : 0.25)),
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
                        Text('Status: $status',
                            style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () => context.push(
                              '/customer/order-progress/${o['_id']}'),
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