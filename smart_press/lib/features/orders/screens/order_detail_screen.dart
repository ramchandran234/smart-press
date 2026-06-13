// lib/features/orders/screens/order_detail_screen.dart
// PPT Screen 9 — Order Detail Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orderId),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Timeline
            _statusTimeline(),
            const SizedBox(height: 16),

            // Customer card
            _infoCard('Customer Details', [
              _infoRow(Icons.person_outline,
                  'Priya Sharma', AppColors.accent2),
              _infoRow(Icons.phone_outlined,
                  '+91 98765 43210', AppColors.green),
              _infoRow(Icons.location_on_outlined,
                  'Koramangala 4th Block, Bengaluru',
                  AppColors.orange),
            ]),
            const SizedBox(height: 12),

            // Order info
            _infoCard('Order Details', [
              _infoRow(Icons.local_laundry_service_outlined,
                  'Service: Wash + Iron', AppColors.accent),
              _infoRow(Icons.category_outlined,
                  'Type: Pickup', AppColors.accent2),
              _infoRow(Icons.calendar_today_outlined,
                  'Created: 05 May 2026', AppColors.textSub),
              _infoRow(Icons.event_available_outlined,
                  'Expected: 07 May 2026', AppColors.textSub),
            ]),
            const SizedBox(height: 12),

            // Garments table
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Garment Breakdown',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textDark)),
                  ),
                  const Divider(height: 1),
                  _garmentTableHeader(),
                  _garmentRow('Shirt', 2, 40),
                  _garmentRow('Trouser', 1, 50),
                  _garmentRow('Saree', 2, 80),
                  const Divider(height: 1),
                  _totalRow('Subtotal', '₹290'),
                  _totalRow('Delivery Charge', '₹40'),
                  _totalRow('Total', '₹330', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Payment status
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.green.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle,
                      color: AppColors.green),
                  SizedBox(width: 10),
                  Text('Payment: PAID — ₹330',
                      style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            AppButton(
              label: 'Update Status',
              onTap: () =>
                  context.push('/orders/$orderId/status'),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'View Invoice',
              onTap: () =>
                  context.push('/invoices/$orderId'),
              color: AppColors.accent2,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Collect Payment',
              onTap: () =>
                  context.push('/collect-payment'),
              color: AppColors.gold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTimeline() {
    final steps = [
      {'label': 'Received', 'done': true},
      {'label': 'Washing', 'done': true},
      {'label': 'Ironing', 'done': false},
      {'label': 'Ready', 'done': false},
      {'label': 'Delivered', 'done': false},
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Status',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 14),
          Row(
            children: steps.asMap().entries.map((e) {
              final i = e.key;
              final step = e.value;
              final done = step['done'] as bool;
              final isLast = i == steps.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: done
                                ? AppColors.green
                                : AppColors.cardBorder,
                            child: Icon(
                              done
                                  ? Icons.check
                                  : Icons.circle,
                              size: done ? 14 : 6,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(step['label'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: done
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: done
                                      ? AppColors.green
                                      : AppColors.textSub)),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: done
                              ? AppColors.green
                              : AppColors.cardBorder,
                          margin: const EdgeInsets.only(
                              bottom: 22),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
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
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
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

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _garmentTableHeader() {
    return Container(
      color: AppColors.highlight,
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      child: const Row(
        children: [
          Expanded(
              child: Text('Item',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSub))),
          SizedBox(
              width: 40,
              child: Text('Qty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSub))),
          SizedBox(
              width: 60,
              child: Text('Amount',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSub))),
        ],
      ),
    );
  }

  Widget _garmentRow(String name, int qty, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(name,
              style: const TextStyle(fontSize: 13))),
          SizedBox(
              width: 40,
              child: Text('x$qty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSub))),
          SizedBox(
              width: 60,
              child: Text('₹${qty * price}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 14 : 13,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: bold
                      ? AppColors.textDark
                      : AppColors.textSub)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: FontWeight.bold,
                  color: bold
                      ? AppColors.accent2
                      : AppColors.textDark)),
        ],
      ),
    );
  }
}