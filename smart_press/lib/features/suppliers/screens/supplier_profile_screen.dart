// lib/features/suppliers/screens/supplier_profile_screen.dart
// PPT Screen 28 — Supplier Profile Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class SupplierProfileScreen extends StatelessWidget {
  final String supplierId;
  const SupplierProfileScreen(
      {super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.darkBg,
                      AppColors.gold
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
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color:
                              AppColors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.store,
                            size: 32,
                            color: AppColors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text('Rajan Chemicals',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white)),
                      const Text('Detergent Supplier',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12)),
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
                  // Stats
                  Row(children: [
                    _statCard('Total Expense',
                        '₹18,400', AppColors.accent2),
                    const SizedBox(width: 10),
                    _statCard('Outstanding',
                        '₹2,400', AppColors.red),
                    const SizedBox(width: 10),
                    _statCard('Payments', '12',
                        AppColors.green),
                  ]),
                  const SizedBox(height: 16),

                  // Contact
                  _infoCard('Contact Details', [
                    _row(Icons.phone_outlined,
                        '+91 98765 11111',
                        AppColors.green),
                    _row(Icons.location_on_outlined,
                        'Shivajinagar, Bengaluru',
                        AppColors.orange),
                    _row(Icons.qr_code,
                        'UPI: rajanchemicals@upi',
                        AppColors.gold),
                  ]),
                  const SizedBox(height: 12),

                  // Recent payments
                  const Text('Payment History',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 10),
                  ...[
                    {'date': '01 May', 'amount': '₹1,200',
                      'mode': 'UPI'},
                    {'date': '15 Apr', 'amount': '₹800',
                      'mode': 'Cash'},
                    {'date': '01 Apr', 'amount': '₹1,500',
                      'mode': 'UPI'},
                  ].map((p) => Card(
                        margin:
                            const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.green
                                .withOpacity(0.12),
                            child: const Icon(
                                Icons.check_circle_outline,
                                color: AppColors.green,
                                size: 20),
                          ),
                          title: Text(p['amount']!,
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold)),
                          subtitle: Text(
                              '${p['date']}  •  ${p['mode']}',
                              style: const TextStyle(
                                  fontSize: 12)),
                          trailing: const Icon(
                              Icons.receipt_outlined,
                              color: AppColors.textSub),
                        ),
                      )),
                  const SizedBox(height: 16),

                  AppButton(
                    label: 'Pay Now',
                    color: AppColors.gold,
                    onTap: () => context
                        .push('/suppliers/$supplierId/pay'),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Show Supplier QR',
                    color: AppColors.accent2,
                    onTap: () => context
                        .push('/suppliers/$supplierId/qr'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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