// lib/features/customer/screens/customer_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _activeCount = 0;
  int _readyCount = 0;
  double _dueAmount = 0.0;
  List<dynamic> _customerOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final res = await OrderService.getCustomerAppOrders();
      if (res['success'] == true) {
        final ordersList = res['orders'] as List<dynamic>;
        
        int active = 0;
        int ready = 0;
        double due = 0.0;
        
        for (var o in ordersList) {
          final status = o['status'] as String? ?? 'received';
          if (status == 'ready') {
            ready++;
            active++;
          } else if (status != 'delivered' && status != 'cancelled') {
            active++;
          }
          
          if (o['isPaid'] == false) {
            due += ((o['totalAmount'] as num? ?? 0.0) - (o['paidAmount'] as num? ?? 0.0)).toDouble();
          }
        }
        
        if (mounted) {
          setState(() {
            _activeCount = active;
            _readyCount = ready;
            _dueAmount = due;
            _customerOrders = ordersList;
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

  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5  && h < 12) return 'Good Morning 🌅';
    if (h >= 12 && h < 17) return 'Good Afternoon ☀️';
    if (h >= 17 && h < 21) return 'Good Evening 🌆';
    return 'Good Night 🌙';
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

  double _getProgressValue(String status) {
    switch (status) {
      case 'received': return 0.25;
      case 'washing': return 0.50;
      case 'ironing': return 0.75;
      case 'ready': return 0.90;
      default: return 0.10;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'received': return '🫧 Order Received';
      case 'washing': return '🫧 Washing in Progress';
      case 'ironing': return '🫧 Ironing in Progress';
      case 'ready': return '✨ Order Ready for Delivery';
      default: return 'Order Received';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrder = _customerOrders.firstWhere(
      (o) => o['status'] != 'delivered' && o['status'] != 'cancelled',
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(),
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70),
            ),
            const Text('My Laundry',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(
                  Icons.notifications_none),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                  Icons.settings_outlined),
              onPressed: () => context
                  .push('/customer/settings')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // KPI row
              Row(children: [
                _kpi('Active', '$_activeCount',
                    Icons.local_laundry_service,
                    AppColors.accent),
                const SizedBox(width: 10),
                _kpi('Ready', '$_readyCount',
                    Icons.check_circle_outline,
                    AppColors.green),
                const SizedBox(width: 10),
                _kpi('Due', '₹${_dueAmount.toStringAsFixed(0)}',
                    Icons.payments_outlined,
                    AppColors.red),
              ]),
              const SizedBox(height: 16),
  
              // Active order card
              if (_loading)
                const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: AppColors.accent)))
              else if (activeOrder != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.accent2,
                        AppColors.accent,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Active Order',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12)),
                          Text(activeOrder['orderId'] as String? ?? '',
                              style: const TextStyle(
                                  color: AppColors.gold,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                          _getStatusText(activeOrder['status'] as String? ?? 'received'),
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _getProgressValue(activeOrder['status'] as String? ?? 'received'),
                          backgroundColor:
                              Colors.white.withOpacity(
                                  0.2),
                          valueColor:
                              const AlwaysStoppedAnimation(
                                  AppColors.gold),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Received→Washing→Ready→Done',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 10),
                          ),
                          GestureDetector(
                            onTap: () => context.push(
                                '/customer/order-progress/${activeOrder['_id']}'),
                            child: const Text('Track →',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 40, color: AppColors.textSub),
                      SizedBox(height: 8),
                      Text(
                        'No Active Orders',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Place a laundry order to track updates here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textSub),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
  
              // Quick actions
              const Text('Quick Actions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _tile(context, Icons.list_alt,
                      'My Orders', AppColors.accent,
                      '/customer/orders'),
                  _tile(context, Icons.store_outlined,
                      'Vendors', AppColors.orange,
                      '/customer/vendors'),
                  _tile(context, Icons.payment,
                      'Pay Now', AppColors.green,
                      '/customer/payments'),
                  _tile(context, Icons.receipt_long,
                      'Invoices', AppColors.accent2,
                      '/customer/payment-history'),
                  _tile(context, Icons.local_shipping,
                      'Schedule', AppColors.gold,
                      '/customer/delivery-mode'),
                  _tile(context,
                      Icons.qr_code_scanner,
                      'Scan QR', AppColors.darkBg,
                      '/customer/orders'),
                  _tile(context, Icons.track_changes,
                      'Track', AppColors.red,
                      '/customer/orders'),
                  _tile(context, Icons.support_agent,
                      'Support', AppColors.textSub,
                      '/customer/settings'),
                ],
              ),
              const SizedBox(height: 20),
  
              // Recent orders
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Orders',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  TextButton(
                      onPressed: () => context
                          .push('/customer/orders'),
                      child: const Text('See All →',
                          style: TextStyle(
                              color:
                                  AppColors.accent))),
                ],
              ),
              const SizedBox(height: 8),
              if (_loading)
                const Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (_customerOrders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No orders found', style: TextStyle(color: AppColors.textSub)),
                  ),
                )
              else
                ..._customerOrders.take(3).map((o) {
                  final shop = o['owner'] as Map<String, dynamic>?;
                  final shopName = shop != null ? shop['shopName'] as String? ?? 'Smart Press' : 'Smart Press';
                  final status = o['status'] as String? ?? 'received';
                  return _orderCard(
                    context,
                    o['_id'] as String? ?? '',
                    o['orderId'] as String? ?? '',
                    shopName,
                    status,
                    '₹${(o['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
                    _getStatusColor(status),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _nav(context, 0),
    );
  }

  Widget _kpi(String label, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textSub)),
        ]),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon,
      String label, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 9,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(BuildContext context,
      String dbId, String id, String shop, String status,
      String amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => context
            .push('/customer/order-detail/$dbId'),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(
              Icons.local_laundry_service,
              color: color,
              size: 20),
        ),
        title: Text(shop,
            style: const TextStyle(
                fontWeight: FontWeight.bold)),
        subtitle: Text(id,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSub)),
        trailing: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
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
      ),
    );
  }

  Widget _nav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Vendors'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
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