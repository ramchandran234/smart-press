// lib/features/dashboard/screens/home_dashboard_screen.dart
// PPT Screen 5 — Home Dashboard
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning 👋',
                style: TextStyle(fontSize: 13, color: Colors.white70)),
            Text('Smart Press',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () => context.push('/qr-scanner')),
          IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards Row
            Row(children: [
              _kpiCard('Orders', '24',
                  Icons.receipt_long, AppColors.accent),
              const SizedBox(width: 10),
              _kpiCard('Pickups', '8',
                  Icons.local_shipping, AppColors.orange),
              const SizedBox(width: 10),
              _kpiCard('Delivered', '12',
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
                  const Text('₹ 3,840',
                      style: TextStyle(
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
                    'New Order', AppColors.accent, '/orders/new'),
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
                    'Schedule', AppColors.darkBg, '/schedule'),
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
            _orderCard(context, 'ORD001', 'Priya Sharma',
                'Washing', '₹240', AppColors.orange),
            _orderCard(context, 'ORD002', 'Raj Kumar',
                'Ready', '₹180', AppColors.green),
            _orderCard(context, 'ORD003', 'Anita Singh',
                'Received', '₹320', AppColors.accent),
            _orderCard(context, 'ORD004', 'Suresh Babu',
                'Delivered', '₹560', AppColors.textSub),
          ],
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
      String label, Color color, String route) {
    return GestureDetector(
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

  Widget _orderCard(BuildContext context, String id, String name,
      String status, String amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => context.push('/orders/$id'),
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