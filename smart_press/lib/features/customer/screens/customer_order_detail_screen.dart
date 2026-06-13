// lib/features/customer/screens/customer_order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class CustomerOrderDetailScreen extends StatelessWidget {
  final String orderId;
  const CustomerOrderDetailScreen(
      {super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text('Order $orderId'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color:
                        AppColors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                          AppColors.orange.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                        Icons.local_laundry_service,
                        color: AppColors.orange,
                        size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Washing in Progress',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.orange)),
                        Text('Expected: 07 May 2026',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(
                        '/customer/order-progress/$orderId'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Text('Track',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shop info
            _infoCard('Shop Details', [
              _row(Icons.store, 'Smart Press',
                  AppColors.accent2),
              _row(Icons.location_on_outlined,
                  'Koramangala 4th Block, Bengaluru',
                  AppColors.orange),
              _row(Icons.phone_outlined,
                  '+91 98765 00000', AppColors.green),
            ]),
            const SizedBox(height: 12),

            // Garments
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Garment Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  const Divider(height: 1),
                  _garmentRow('Shirt', 2, 40),
                  _garmentRow('Trouser', 1, 50),
                  _garmentRow('Saree', 2, 80),
                  const Divider(height: 1),
                  _totalRow('Subtotal', '₹290'),
                  _totalRow('Delivery', '₹40'),
                  _totalRow('Total', '₹330', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Payment status
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment,
                      color: AppColors.red),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Payment Pending — ₹330',
                        style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.bold)),
                  ),
                  GestureDetector(
                    onTap: () => context
                        .push('/customer/payments'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Text('Pay Now',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            AppButton(
              label: 'View Invoice',
              onTap: () =>
                  context.push('/invoices/$orderId'),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Track Order',
              color: AppColors.orange,
              onTap: () => context.push(
                  '/customer/order-progress/$orderId'),
            ),
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

  Widget _garmentRow(String name, int qty, int rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text('x$qty',
              style: const TextStyle(
                  color: AppColors.textSub)),
          const SizedBox(width: 20),
          Text('₹${qty * rate}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600)),
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
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: bold
                      ? AppColors.textDark
                      : AppColors.textSub)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: bold ? 16 : 13,
                  color: bold
                      ? AppColors.accent2
                      : AppColors.textDark)),
        ],
      ),
    );
  }
}