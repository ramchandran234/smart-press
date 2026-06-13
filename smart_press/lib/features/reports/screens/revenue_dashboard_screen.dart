// lib/features/reports/screens/revenue_dashboard_screen.dart
// PPT Screen 34 — Revenue Dashboard Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

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

  final _barData = [
    {'day': 'Mon', 'val': 0.6},
    {'day': 'Tue', 'val': 0.8},
    {'day': 'Wed', 'val': 0.5},
    {'day': 'Thu', 'val': 1.0},
    {'day': 'Fri', 'val': 0.75},
    {'day': 'Sat', 'val': 0.9},
    {'day': 'Sun', 'val': 0.4},
  ];

  final _topCustomers = [
    {'name': 'Priya Sharma', 'amount': '₹4,820',
      'orders': 12},
    {'name': 'Anita Singh', 'amount': '₹3,640',
      'orders': 23},
    {'name': 'Deepa Nair', 'amount': '₹2,980',
      'orders': 17},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Revenue Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () =>
                context.push('/reports/export'),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    onTap: () =>
                        setState(() => _period = p),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.accent2
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent2
                                : AppColors.cardBorder),
                      ),
                      child: Text(p,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: sel
                                  ? AppColors.white
                                  : AppColors.textSub)),
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
                  colors: [
                    AppColors.darkBg,
                    AppColors.accent2
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text('$_period Revenue',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  const Text('₹ 38,450',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.trending_up,
                        color: AppColors.green, size: 16),
                    const SizedBox(width: 4),
                    const Text('+18% vs last period',
                        style: TextStyle(
                            color: AppColors.green,
                            fontSize: 12)),
                    const Spacer(),
                    Text('Avg/day: ₹1,281',
                        style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 11)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bar chart
            const Text('Daily Revenue Trend',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: _barData.map((d) {
                        final val = d['val'] as double;
                        return Column(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 28,
                              height: val * 100,
                              decoration: BoxDecoration(
                                color: val == 1.0
                                    ? AppColors.accent
                                    : AppColors.accent
                                        .withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(
                                        6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(d['day'] as String,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color:
                                        AppColors.textSub)),
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
              _kpiCard('Orders', '142', AppColors.accent),
              const SizedBox(width: 10),
              _kpiCard('Avg Order', '₹271', AppColors.gold),
              const SizedBox(width: 10),
              _kpiCard('Repeat %', '68%', AppColors.green),
            ]),
            const SizedBox(height: 20),

            // Top customers
            const Text('Top Customers',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 10),
            ..._topCustomers.asMap().entries.map((e) {
              final i = e.key;
              final c = e.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppColors.accent.withOpacity(0.12),
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent2)),
                  ),
                  title: Text(c['name'] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  subtitle: Text('${c['orders']} orders',
                      style: const TextStyle(fontSize: 12)),
                  trailing: Text(c['amount'] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.accent2)),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Nav to other reports
            Row(children: [
              Expanded(
                  child: _reportNav(context,
                      'Profit', Icons.pie_chart,
                      AppColors.accent2,
                      '/reports/profit')),
              const SizedBox(width: 10),
              Expanded(
                  child: _reportNav(context,
                      'Receivables', Icons.money_off,
                      AppColors.red,
                      '/reports/receivables')),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: _reportNav(context,
                      'Breakdown', Icons.bar_chart,
                      AppColors.orange,
                      '/reports/breakdown')),
              const SizedBox(width: 10),
              Expanded(
                  child: _reportNav(context,
                      'Export', Icons.download,
                      AppColors.green,
                      '/reports/export')),
            ]),
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
          color: AppColors.white,
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
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
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