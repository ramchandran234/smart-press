// lib/features/reports/screens/revenue_report_screen.dart
// PPT Screen 37 — Revenue Report Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class RevenueReportScreen extends StatelessWidget {
  const RevenueReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Channel breakdown
            const Text('Revenue by Channel',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),
            ...[
              {'label': 'Walk-in', 'amount': '₹14,200',
                'pct': 0.37, 'color': AppColors.accent},
              {'label': 'Pickup', 'amount': '₹15,800',
                'pct': 0.41, 'color': AppColors.orange},
              {'label': 'Delivery', 'amount': '₹8,450',
                'pct': 0.22, 'color': AppColors.green},
            ].map((c) => _channelBar(c)),
            const SizedBox(height: 20),

            // Service breakdown
            const Text('Revenue by Service',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),
            Row(children: [
              _serviceCard('Wash + Iron', '₹18,400',
                  '48%', AppColors.accent),
              const SizedBox(width: 10),
              _serviceCard('Dry Clean', '₹12,600',
                  '33%', AppColors.accent2),
              const SizedBox(width: 10),
              _serviceCard('Iron Only', '₹7,450',
                  '19%', AppColors.orange),
            ]),
            const SizedBox(height: 20),

            // Metrics
            const Text('Performance Metrics',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),
            Row(children: [
              _metricCard('Completion Rate',
                  '94%', AppColors.green),
              const SizedBox(width: 10),
              _metricCard('Cancellation',
                  '6%', AppColors.red),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _metricCard('Repeat Customers',
                  '68%', AppColors.accent2),
              const SizedBox(width: 10),
              _metricCard('Avg Order Value',
                  '₹271', AppColors.gold),
            ]),
            const SizedBox(height: 20),

            // Peak hours
            const Text('Peak Hours',
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
                  '9AM-11AM', '11AM-1PM',
                  '4PM-6PM', '6PM-8PM'
                ].asMap().entries.map((e) {
                  final widths = [0.7, 0.5, 0.9, 0.6];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(e.value,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color:
                                      AppColors.textSub)),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: widths[e.key],
                              backgroundColor:
                                  AppColors.cardBorder,
                              valueColor:
                                  const AlwaysStoppedAnimation(
                                      AppColors.accent),
                              minHeight: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                            '${(widths[e.key] * 100).toInt()}%',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _channelBar(Map c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(c['label'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              Text(c['amount'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: c['pct'] as double,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation(
                  c['color'] as Color),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(String label, String amount,
      String pct, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(pct,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(amount,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
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

  Widget _metricCard(
      String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: color)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSub)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}