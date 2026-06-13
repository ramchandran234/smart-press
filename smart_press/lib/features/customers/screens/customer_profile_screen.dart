// lib/features/customers/screens/customer_profile_screen.dart
// PPT Screen 19 — Customer Profile Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class CustomerProfileScreen extends StatelessWidget {
  final String customerId;
  const CustomerProfileScreen(
      {super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.darkBg,
                      AppColors.accent2
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 36,
                        backgroundColor:
                            AppColors.white.withOpacity(0.2),
                        child: const Text('P',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white)),
                      ),
                      const SizedBox(height: 10),
                      const Text('Priya Sharma',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white)),
                      const Text('+91 98765 43210',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {}),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(children: [
                    _statCard('Lifetime Spend',
                        '₹4,820', AppColors.accent2),
                    const SizedBox(width: 10),
                    _statCard('Total Orders', '12',
                        AppColors.accent),
                    const SizedBox(width: 10),
                    _statCard('Pending Due', '₹340',
                        AppColors.red),
                  ]),
                  const SizedBox(height: 16),

                  // Contact info
                  _infoCard('Contact Details', [
                    _row(Icons.phone_outlined,
                        '+91 98765 43210',
                        AppColors.green),
                    _row(Icons.chat_outlined,
                        'WhatsApp: +91 98765 43210',
                        AppColors.green),
                    _row(Icons.location_on_outlined,
                        'Koramangala 4th Block, Bengaluru',
                        AppColors.orange),
                    _row(Icons.access_time,
                        'Preferred Slot: Morning (9AM–12PM)',
                        AppColors.accent2),
                  ]),
                  const SizedBox(height: 12),

                  // Recent orders
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Orders',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      TextButton(
                        onPressed: () => context.push(
                            '/customers/$customerId/orders'),
                        child: const Text('See All →',
                            style: TextStyle(
                                color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...[
                    {'id': 'ORD001', 'date': '05 May',
                      'amount': '₹240', 'status': 'Washing',
                      'color': AppColors.orange},
                    {'id': 'ORD091', 'date': '28 Apr',
                      'amount': '₹480', 'status': 'Delivered',
                      'color': AppColors.green},
                    {'id': 'ORD082', 'date': '15 Apr',
                      'amount': '₹180', 'status': 'Delivered',
                      'color': AppColors.green},
                  ].map((o) => Card(
                        margin:
                            const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () => context
                              .push('/orders/${o['id']}'),
                          leading: CircleAvatar(
                            backgroundColor: (o['color']
                                    as Color)
                                .withOpacity(0.12),
                            child: Icon(Icons.receipt_long,
                                color: o['color'] as Color,
                                size: 18),
                          ),
                          title: Text(o['id'] as String,
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold)),
                          subtitle: Text(o['date'] as String,
                              style: const TextStyle(
                                  fontSize: 12)),
                          trailing: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(o['amount'] as String,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2),
                                decoration: BoxDecoration(
                                  color: (o['color'] as Color)
                                      .withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(
                                          10),
                                ),
                                child: Text(
                                    o['status'] as String,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: o['color']
                                            as Color,
                                        fontWeight:
                                            FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),

                  // Actions
                  AppButton(
                    label: 'Create New Order',
                    onTap: () =>
                        context.push('/orders/new'),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Collect Payment  ₹340',
                    onTap: () =>
                        context.push('/collect-payment'),
                    color: AppColors.gold,
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'View All Orders',
                    onTap: () => context.push(
                        '/customers/$customerId/orders'),
                    color: AppColors.accent2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSub)),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          const Divider(height: 1),
          ...rows.map((r) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              child: r)),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}