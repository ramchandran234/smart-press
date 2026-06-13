// lib/features/customer/screens/customer_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  // ── Greeting based on time ─────────────────────────
  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5  && h < 12) return 'Good Morning 🌅';
    if (h >= 12 && h < 17) return 'Good Afternoon ☀️';
    if (h >= 17 && h < 21) return 'Good Evening 🌆';
    return 'Good Night 🌙';
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // KPI row
            Row(children: [
              _kpi('Active', '2',
                  Icons.local_laundry_service,
                  AppColors.accent),
              const SizedBox(width: 10),
              _kpi('Ready', '1',
                  Icons.check_circle_outline,
                  AppColors.green),
              const SizedBox(width: 10),
              _kpi('Due', '₹340',
                  Icons.payments_outlined,
                  AppColors.red),
            ]),
            const SizedBox(height: 16),

            // Active order card
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
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Order',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12)),
                      Text('ORD001',
                          style: TextStyle(
                              color: AppColors.gold,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      '🫧 Washing in Progress',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.4,
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
                            '/customer/order-progress/ORD001'),
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
            _orderCard(context, 'ORD001',
                'Smart Press', 'Washing',
                '₹240', AppColors.orange),
            _orderCard(context, 'ORD091',
                'Smart Press', 'Delivered',
                '₹480', AppColors.green),
          ],
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
      String id, String shop, String status,
      String amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => context
            .push('/customer/order-detail/$id'),
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