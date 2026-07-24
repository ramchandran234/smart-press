// lib/features/payments/screens/collect_payment_screen.dart
// PPT Screen 21 — Collect Payment Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';
import '../../../shared/widgets/app_button.dart';

class CollectPaymentScreen extends StatefulWidget {
  final String orderId;
  const CollectPaymentScreen({super.key, required this.orderId});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  String _mode = 'Online';
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      final res = await OrderService.getOrderById(widget.orderId);
      if (res['success'] == true) {
        setState(() {
          _order = res['order'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitPayment() async {
    if (_order == null) return;
    
    setState(() => _isSubmitting = true);
    final total = (_order!['totalAmount'] as num?)?.toDouble() ?? 0.0;

    try {
      // 1. Record payment
      final payRes = await OrderService.collectPayment(
        widget.orderId,
        amount: total,
        paymentMode: _mode.toLowerCase(),
      );

      if (payRes['success'] != true) {
        setState(() => _isSubmitting = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(payRes['error'] ?? 'Payment failed'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      // 2. Close order by updating status to delivered
      await OrderService.updateStatus(
        widget.orderId,
        'delivered',
        note: 'Payment collected via $_mode',
      );

      setState(() => _isSubmitting = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment recorded and order closed!'),
          backgroundColor: AppColors.green,
        ),
      );
      context.pop();
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Collect Payment')),
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Collect Payment')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final total = _order!['totalAmount'] as num? ?? 0;
    final customer = _order!['customer'] as Map<String, dynamic>?;
    final customerName = customer?['name'] as String? ?? 'Customer';
    final orderIdDisplay = _order!['orderId'] ?? widget.orderId;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: const Text('Collect Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkBg, AppColors.accent2],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order: $orderIdDisplay',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      Text(customerName,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('₹ $total',
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Amount Due',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment mode toggle
            const Text('Payment Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              children: ['Online', 'Offline'].map((m) {
                final sel = _mode == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.accent : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            m == 'Online' ? Icons.phone_android : Icons.money,
                            color: sel ? AppColors.white : AppColors.textSub,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sel
                                    ? AppColors.white
                                    : AppColors.textSub),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            _isSubmitting
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : AppButton(
                    label: 'Record Payment & Close Order',
                    onTap: _submitPayment,
                  ),
          ],
        ),
      ),
    );
  }
}