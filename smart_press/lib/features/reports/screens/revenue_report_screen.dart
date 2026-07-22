// lib/features/reports/screens/revenue_report_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

class RevenueReportScreen extends StatefulWidget {
  const RevenueReportScreen({super.key});

  @override
  State<RevenueReportScreen> createState() => _RevenueReportScreenState();
}

class _RevenueReportScreenState extends State<RevenueReportScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    try {
      final res = await OrderService.getOrders();
      if (res['success'] == true && mounted) {
        setState(() {
          _orders = res['orders'] as List<dynamic>;
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalRev = 0.0;
    double walkInRev = 0.0;
    double pickupRev = 0.0;
    double deliveryRev = 0.0;

    int washIronCount = 0;
    int dryCleanCount = 0;
    int ironOnlyCount = 0;

    int deliveredCount = 0;
    int cancelledCount = 0;

    for (var o in _orders) {
      final amt = (o['totalAmount'] as num? ?? 0).toDouble();
      totalRev += amt;

      final type = (o['orderType'] as String? ?? 'walk-in').toLowerCase();
      if (type == 'pickup') {
        pickupRev += amt;
      } else if (type == 'delivery') {
        deliveryRev += amt;
      } else {
        walkInRev += amt;
      }

      final st = (o['serviceType'] as String? ?? 'Wash + Iron').toLowerCase();
      if (st.contains('dry')) {
        dryCleanCount++;
      } else if (st.contains('only') || st.contains('iron')) {
        ironOnlyCount++;
      } else {
        washIronCount++;
      }

      final status = (o['status'] as String? ?? '').toLowerCase();
      if (status == 'delivered') deliveredCount++;
      if (status == 'cancelled') cancelledCount++;
    }

    final safeRev = totalRev > 0 ? totalRev : 1.0;
    final walkInPct = walkInRev / safeRev;
    final pickupPct = pickupRev / safeRev;
    final deliveryPct = deliveryRev / safeRev;

    final totalServiceOrders = washIronCount + dryCleanCount + ironOnlyCount;
    final safeService = totalServiceOrders > 0 ? totalServiceOrders : 1;
    final washPct = ((washIronCount / safeService) * 100).round();
    final dryPct = ((dryCleanCount / safeService) * 100).round();
    final ironPct = ((ironOnlyCount / safeService) * 100).round();

    final totalOrdersCount = _orders.length;
    final completionRate = totalOrdersCount > 0 ? ((deliveredCount / totalOrdersCount) * 100).round() : 0;
    final cancellationRate = totalOrdersCount > 0 ? ((cancelledCount / totalOrdersCount) * 100).round() : 0;
    final avgOrderVal = totalOrdersCount > 0 ? (totalRev / totalOrdersCount).round() : 0;

    final channelData = [
      {'label': 'Walk-in', 'amount': '₹${walkInRev.toStringAsFixed(0)}', 'pct': walkInPct, 'color': AppColors.accent},
      {'label': 'Pickup', 'amount': '₹${pickupRev.toStringAsFixed(0)}', 'pct': pickupPct, 'color': AppColors.orange},
      {'label': 'Delivery', 'amount': '₹${deliveryRev.toStringAsFixed(0)}', 'pct': deliveryPct, 'color': AppColors.green},
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Revenue Breakdown Report', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel breakdown
                  const Text('Revenue by Channel (Live)',
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
                      children: channelData.map((c) => _channelBar(c)).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Service breakdown
                  const Text('Revenue by Service Type',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.white)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _serviceCard('Wash + Iron', '$washIronCount orders',
                        '$washPct%', AppColors.accent),
                    const SizedBox(width: 10),
                    _serviceCard('Dry Clean', '$dryCleanCount orders',
                        '$dryPct%', AppColors.accent2),
                    const SizedBox(width: 10),
                    _serviceCard('Iron Only', '$ironOnlyCount orders',
                        '$ironPct%', AppColors.orange),
                  ]),
                  const SizedBox(height: 20),

                  // Performance metrics
                  const Text('Performance Metrics (Live DB)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.white)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _metricCard('Completion Rate',
                        '$completionRate%', AppColors.green),
                    const SizedBox(width: 10),
                    _metricCard('Cancellation',
                        '$cancellationRate%', AppColors.red),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _metricCard('Total Orders',
                        '$totalOrdersCount', AppColors.accent2),
                    const SizedBox(width: 10),
                    _metricCard('Avg Order Value',
                        '₹$avgOrderVal', AppColors.gold),
                  ]),
                  const SizedBox(height: 30),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c['label'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.white)),
              Text(c['amount'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (c['pct'] as double).clamp(0.0, 1.0),
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

  Widget _serviceCard(String label, String count,
      String pct, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(pct,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(count,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.white)),
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
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
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