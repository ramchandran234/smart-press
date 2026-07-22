// lib/features/reports/screens/revenue_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

class RevenueDashboardScreen extends StatefulWidget {
  const RevenueDashboardScreen({super.key});

  @override
  State<RevenueDashboardScreen> createState() =>
      _RevenueDashboardScreenState();
}

class _RevenueDashboardScreenState
    extends State<RevenueDashboardScreen> {
  String _period = 'This Month';
  final _periods = ['Today', 'This Week', 'This Month'];

  List<dynamic> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRevenueData();
  }

  Future<void> _fetchRevenueData() async {
    try {
      final res = await OrderService.getOrders();
      if (res['success'] == true && mounted) {
        setState(() {
          _allOrders = res['orders'] as List<dynamic>;
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<dynamic> get _periodOrders {
    final now = DateTime.now();
    return _allOrders.where((o) {
      if (o['createdAt'] == null) return false;
      final dt = DateTime.parse(o['createdAt'].toString());
      if (_period == 'Today') {
        return dt.year == now.year && dt.month == now.month && dt.day == now.day;
      } else if (_period == 'This Week') {
        final diff = now.difference(dt).inDays;
        return diff >= 0 && diff < 7;
      } else {
        // This Month
        return dt.year == now.year && dt.month == now.month;
      }
    }).toList();
  }

  double get _periodRevenue {
    return _periodOrders.fold(0.0, (sum, o) => sum + ((o['totalAmount'] as num? ?? 0).toDouble()));
  }

  List<Map<String, dynamic>> get _dailyTrend {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final Map<int, double> dayTotals = {for (var i = 1; i <= 7; i++) i: 0.0};
    
    final now = DateTime.now();
    for (var o in _allOrders) {
      if (o['createdAt'] == null) continue;
      final dt = DateTime.parse(o['createdAt'].toString());
      if (now.difference(dt).inDays < 7) {
        dayTotals[dt.weekday] = (dayTotals[dt.weekday] ?? 0.0) + ((o['totalAmount'] as num? ?? 0).toDouble());
      }
    }

    double maxVal = 0.0;
    dayTotals.forEach((_, val) {
      if (val > maxVal) maxVal = val;
    });

    return List.generate(7, (i) {
      final weekday = i + 1;
      final amount = dayTotals[weekday] ?? 0.0;
      final ratio = maxVal > 0 ? (amount / maxVal) : 0.0;
      return {
        'day': days[i],
        'amount': amount,
        'val': ratio < 0.1 && amount > 0 ? 0.1 : ratio,
      };
    });
  }

  List<Map<String, dynamic>> get _topCustomers {
    final Map<String, Map<String, dynamic>> map = {};
    for (var o in _periodOrders) {
      final cust = o['customer'] as Map<String, dynamic>?;
      final name = cust != null ? (cust['name'] as String? ?? 'Walk-in') : 'Walk-in';
      final amt = (o['totalAmount'] as num? ?? 0).toDouble();

      if (!map.containsKey(name)) {
        map[name] = {'name': name, 'amount': 0.0, 'orders': 0};
      }
      map[name]!['amount'] = (map[name]!['amount'] as double) + amt;
      map[name]!['orders'] = (map[name]!['orders'] as int) + 1;
    }

    final list = map.values.toList();
    list.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    return list.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalOrdersCount = _periodOrders.length;
    final avgOrderVal = totalOrdersCount > 0 ? (_periodRevenue / totalOrdersCount).round() : 0;
    final deliveredCount = _periodOrders.where((o) => o['status'] == 'delivered').length;
    final completionPct = totalOrdersCount > 0 ? ((deliveredCount / totalOrdersCount) * 100).round() : 0;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Revenue Dashboard', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchRevenueData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.accent),
            onPressed: () => context.push('/reports/export'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period selector
                  Row(
                    children: _periods.map((p) {
                      final sel = _period == p;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _period = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.accent : AppColors.darkSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: sel ? AppColors.accent : AppColors.cardBorder),
                            ),
                            child: Text(p,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: sel ? AppColors.darkBg : AppColors.white)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Revenue card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.darkSurface, AppColors.darkBg],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_period Revenue (Live DB)',
                            style: const TextStyle(
                                color: AppColors.textSub,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Text('₹ ${_periodRevenue.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.trending_up, color: AppColors.green, size: 18),
                          const SizedBox(width: 4),
                          Text('$totalOrdersCount total orders',
                              style: const TextStyle(
                                  color: AppColors.green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text('Avg/order: ₹$avgOrderVal',
                              style: const TextStyle(
                                  color: AppColors.textSub,
                                  fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bar chart
                  const Text('Weekly Revenue Trend (Live)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.white)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _dailyTrend.map((d) {
                              final val = d['val'] as double;
                              final amt = (d['amount'] as double).round();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (amt > 0)
                                    Text('₹$amt',
                                        style: const TextStyle(
                                            fontSize: 9,
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 24,
                                    height: (val * 80).clamp(4.0, 80.0),
                                    decoration: BoxDecoration(
                                      color: val > 0 ? AppColors.accent : AppColors.cardBorder,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(d['day'] as String,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSub)),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // KPI cards
                  Row(children: [
                    _kpiCard('Total Orders', '$totalOrdersCount', AppColors.accent),
                    const SizedBox(width: 10),
                    _kpiCard('Avg Order', '₹$avgOrderVal', AppColors.gold),
                    const SizedBox(width: 10),
                    _kpiCard('Completion', '$completionPct%', AppColors.green),
                  ]),
                  const SizedBox(height: 20),

                  // Top customers
                  const Text('Top Customers by Spend',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.white)),
                  const SizedBox(height: 10),
                  if (_topCustomers.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Center(
                        child: Text('No order records yet for this period',
                            style: TextStyle(color: AppColors.textSub)),
                      ),
                    )
                  else
                    ..._topCustomers.asMap().entries.map((e) {
                      final i = e.key;
                      final c = e.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accent.withOpacity(0.15),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent)),
                          ),
                          title: Text(c['name'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white)),
                          subtitle: Text('${c['orders']} order(s)',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                          trailing: Text('₹${(c['amount'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.gold)),
                        ),
                      );
                    }),
                  const SizedBox(height: 20),

                  // Nav to other reports
                  Row(children: [
                    Expanded(
                        child: _reportNav(context,
                            'Detailed Report', Icons.bar_chart,
                            AppColors.accent2,
                            '/reports/breakdown')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _reportNav(context,
                            'Export Data', Icons.download,
                            AppColors.green,
                            '/reports/export')),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: _bottomNav(context, 3),
    );
  }

  Widget _kpiCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSub)),
          ],
        ),
      ),
    );
  }

  Widget _reportNav(BuildContext context, String label,
      IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color)),
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
      backgroundColor: AppColors.darkBg,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Customers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: 'Reports'),
      ],
      onTap: (i) {
        const routes = [
          '/home', '/orders',
          '/customers', '/reports/revenue'
        ];
        context.go(routes[i]);
      },
    );
  }
}