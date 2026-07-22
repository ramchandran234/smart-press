// lib/features/dashboard/screens/home_dashboard_screen.dart
// PPT Screen 5 — Home Dashboard
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/order_service.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _activeCount = 0;
  int _pickupCount = 0;
  int _deliveredCount = 0;
  double _todayRevenue = 0.0;
  List<dynamic> _recentOrders = [];
  bool _loading = true;
  bool _isOpen = true;
  bool _updatingStatus = false;

  String _userName = 'Iron Buddy';

  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5  && h < 12) return 'Good Morning 🌅';
    if (h >= 12 && h < 17) return 'Good Afternoon ☀️';
    if (h >= 17 && h < 21) return 'Good Evening 🌆';
    return 'Good Night 🌙';
  }

  Future<void> _fetchDashboardData() async {
    try {
      final profileRes = await AuthService.getProfile();
      if (profileRes['success'] == true && profileRes['user'] != null) {
        final u = profileRes['user'] as Map<String, dynamic>;
        if (u['isOpen'] != null) {
          _isOpen = u['isOpen'] as bool;
        }
        final name = u['shopName'] as String? ?? u['name'] as String?;
        if (name != null && name.isNotEmpty) {
          _userName = name;
        }
      }
    } catch (_) {}

    try {
      final res = await OrderService.getOrders();
      if (res['success'] == true) {
        final ordersList = res['orders'] as List<dynamic>;
        
        int active = 0;
        int pickup = 0;
        int delivered = 0;
        double revenue = 0.0;
        final today = DateTime.now();
        
        for (var o in ordersList) {
          final status = o['status'] as String? ?? 'received';
          final type = o['orderType'] as String? ?? 'walk-in';
          
          if (status == 'delivered') {
            delivered++;
          } else if (status != 'cancelled') {
            active++;
          }
          
          if (type == 'pickup') {
            pickup++;
          }
          
          if (o['createdAt'] != null) {
            final dt = DateTime.parse(o['createdAt']);
            if (dt.year == today.year && dt.month == today.month && dt.day == today.day) {
              revenue += (o['totalAmount'] as num? ?? 0.0).toDouble();
            }
          }
        }
        
        if (mounted) {
          setState(() {
            _activeCount = active;
            _pickupCount = pickup;
            _deliveredCount = delivered;
            _todayRevenue = revenue;
            _recentOrders = ordersList.take(4).toList();
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

  Future<void> _toggleShopStatus(bool val) async {
    setState(() {
      _updatingStatus = true;
      _isOpen = val;
    });
    try {
      final res = await AuthService.updateProfile({'isOpen': val});
      if (res['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(val ? 'Shop is now OPEN for customers!' : 'Shop is now CLOSED!'),
            backgroundColor: val ? AppColors.green : AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {}
    if (mounted) setState(() => _updatingStatus = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(),
                style: const TextStyle(fontSize: 13, color: Colors.white70)),
            Text(_userName,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () => context.push('/qr-scanner')),
          IconButton(
              key: const Key('dashboard_settings_btn'),
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings')),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Open / Closed Toggle Switch Banner
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _isOpen ? AppColors.green.withOpacity(0.12) : AppColors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isOpen ? AppColors.green : AppColors.red),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isOpen ? Icons.storefront : Icons.storefront_outlined,
                      color: _isOpen ? AppColors.green : AppColors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOpen ? 'Shop Status: OPEN' : 'Shop Status: CLOSED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: _isOpen ? AppColors.green : AppColors.red,
                            ),
                          ),
                          Text(
                            _isOpen ? 'Visible to customers • Accepting orders' : 'Visible to customers • Orders paused',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSub),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      key: const Key('shop_status_switch'),
                      value: _isOpen,
                      activeColor: AppColors.green,
                      inactiveThumbColor: AppColors.red,
                      onChanged: _updatingStatus ? null : (v) => _toggleShopStatus(v),
                    ),
                  ],
                ),
              ),

              // KPI Cards Row
              Row(children: [
                _kpiCard('Orders', '$_activeCount',
                    Icons.receipt_long, AppColors.accent),
                const SizedBox(width: 10),
                _kpiCard('Pickups', '$_pickupCount',
                    Icons.local_shipping, AppColors.orange),
                const SizedBox(width: 10),
                _kpiCard('Delivered', '$_deliveredCount',
                    Icons.done_all, AppColors.green),
              ]),
              const SizedBox(height: 16),
  
              // Revenue Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkBg, AppColors.accent2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.darkBg.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Revenue",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text('₹ ${_todayRevenue.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          Icon(Icons.trending_up,
                              color: AppColors.green, size: 16),
                          SizedBox(width: 4),
                          Text('+12% vs yesterday',
                              style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 12)),
                        ]),
                        GestureDetector(
                          onTap: () =>
                              context.push('/reports/revenue'),
                          child: const Text('View Report →',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
  
              // Quick Actions
              const Text('Quick Actions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _actionTile(context, Icons.add_circle_outline,
                      'New Order', AppColors.accent, '/orders/new', key: const Key('qa_new_order')),
                  _actionTile(context, Icons.local_shipping,
                      'Pickups', AppColors.orange, '/pickups'),
                  _actionTile(context, Icons.delivery_dining,
                      'Deliveries', AppColors.green, '/deliveries'),
                  _actionTile(context, Icons.people_outline,
                      'Customers', AppColors.accent2, '/customers'),
                  _actionTile(context, Icons.receipt_outlined,
                      'Invoices', AppColors.red, '/invoices'),
                  _actionTile(context, Icons.payments_outlined,
                      'Payments', AppColors.gold,
                      '/collect-payment'),
                  _actionTile(context, Icons.bar_chart,
                      'Reports', AppColors.accent2,
                      '/reports/revenue'),
                  _actionTile(context, Icons.calendar_month,
                      'Schedule', const Color(0xFF00E5FF), '/schedule'),
                ],
              ),
              const SizedBox(height: 20),
  
              // Recent Orders Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Orders',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  TextButton(
                      onPressed: () => context.push('/orders'),
                      child: const Text('See All →',
                          style:
                              TextStyle(color: AppColors.accent))),
                ],
              ),
              const SizedBox(height: 8),
              if (_loading)
                const Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (_recentOrders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long, size: 48, color: AppColors.textSub),
                        SizedBox(height: 8),
                        Text('No recent orders found', style: TextStyle(color: AppColors.textSub)),
                      ],
                    ),
                  ),
                )
              else
                ..._recentOrders.map((o) {
                  final cust = o['customer'] as Map<String, dynamic>?;
                  final custName = cust != null ? cust['name'] as String? ?? 'Walk-in' : 'Walk-in';
                  return _orderCard(
                    context,
                    o['_id'] as String? ?? '',
                    o['orderId'] as String? ?? '',
                    custName,
                    o['status'] as String? ?? 'received',
                    '₹${(o['totalAmount'] as num? ?? 0).toStringAsFixed(0)}',
                    _getStatusColor(o['status'] as String? ?? 'received'),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context, 0),
    );
  }

  Widget _kpiCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 10),
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSub)),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(BuildContext context, IconData icon,
      String label, Color color, String route, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 5),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(BuildContext context, String dbId, String id, String name,
      String status, String amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => context.push('/orders/$dbId'),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(Icons.receipt_long, color: color, size: 20),
        ),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(id,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSub)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
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
      ),
    );
  }

  Widget _bottomNav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Customers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports'),
      ],
      onTap: (i) {
        const routes = [
          '/home',
          '/orders',
          '/customers',
          '/reports/revenue'
        ];
        context.go(routes[i]);
      },
    );
  }
}