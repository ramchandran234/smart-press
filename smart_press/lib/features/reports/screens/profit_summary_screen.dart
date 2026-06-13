// lib/features/reports/screens/profit_summary_screen.dart
// PPT Screen 35 — Profit Summary Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ProfitSummaryScreen extends StatelessWidget {
  const ProfitSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revenue = 38450;
    final expenses = 12700;
    final profit = revenue - expenses;
    final margin = (profit / revenue * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Summary'),
        actions: [
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () =>
                  context.push('/reports/export')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profit card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.green,
                    AppColors.accent2,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text('Net Profit — This Month',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('₹ $profit',
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                        'Margin: $margin%',
                        style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // P&L summary
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _plRow('Gross Revenue',
                      '₹$revenue', AppColors.green, false),
                  const Divider(height: 1),
                  _plRow('Total Expenses',
                      '−₹$expenses', AppColors.red, false),
                  const Divider(height: 1),
                  _plRow('Net Profit',
                      '₹$profit', AppColors.accent2, true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Expense Breakdown',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),

            ...[
              {'cat': 'Detergent & Supplies',
                'amt': 3600, 'pct': 0.28,
                'color': AppColors.accent},
              {'cat': 'Staff Salary',
                'amt': 5000, 'pct': 0.39,
                'color': AppColors.accent2},
              {'cat': 'Transport',
                'amt': 2100, 'pct': 0.17,
                'color': AppColors.orange},
              {'cat': 'Equipment',
                'amt': 1200, 'pct': 0.09,
                'color': AppColors.gold},
              {'cat': 'Other',
                'amt': 800, 'pct': 0.07,
                'color': AppColors.textSub},
            ].map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e['cat'] as String,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600)),
                          Text('₹${e['amt']}',
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: e['pct'] as double,
                          backgroundColor:
                              AppColors.cardBorder,
                          valueColor:
                              AlwaysStoppedAnimation(
                                  e['color'] as Color),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _plRow(String label, String value,
      Color color, bool bold) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 15 : 14,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: AppColors.textDark)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 18 : 15,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}