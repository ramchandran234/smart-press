// lib/features/orders/screens/order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';
import '../../../shared/widgets/app_button.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Order: ${widget.orderId}')),
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Order: ${widget.orderId}')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final customer = _order!['customer'] as Map<String, dynamic>?;
    final customerName = customer?['name'] as String? ?? 'Walk-in';
    final customerMobile = customer?['mobile'] as String? ?? '';
    
    final addressLine1 = customer?['addressLine1'] as String? ?? '';
    final area = customer?['area'] as String? ?? '';
    final city = customer?['city'] as String? ?? '';
    final addressList = [addressLine1, area, city].where((s) => s.isNotEmpty).toList();
    final customerAddress = addressList.isNotEmpty ? addressList.join(', ') : 'Not provided';

    final serviceType = _order!['serviceType'] as String? ?? 'Wash + Iron';
    final orderType = _order!['orderType'] as String? ?? 'walk-in';
    
    final createdAtStr = _order!['createdAt'] as String? ?? '';
    final createdDate = createdAtStr.isNotEmpty 
        ? createdAtStr.substring(0, 10) 
        : 'Unknown';

    final expectedAtStr = _order!['expectedDate'] as String? ?? '';
    final expectedDate = expectedAtStr.isNotEmpty 
        ? expectedAtStr.substring(0, 10) 
        : 'Flexible';

    final garments = _order!['garments'] as List<dynamic>? ?? [];
    final subtotal = _order!['subtotal'] as num? ?? 0;
    final deliveryCharge = _order!['deliveryCharge'] as num? ?? 0;
    final totalAmount = _order!['totalAmount'] as num? ?? 0;
    final isPaid = _order!['isPaid'] as bool? ?? false;

    final currentStatus = _order!['status'] as String? ?? 'received';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('Order: ${_order!['orderId'] ?? widget.orderId}'),
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
            _statusTimeline(currentStatus),
            const SizedBox(height: 16),

            // Customer card
            _infoCard('Customer Details', [
              _infoRow(Icons.person_outline, customerName, AppColors.accent2),
              if (customerMobile.isNotEmpty)
                _infoRow(Icons.phone_outlined, '+91 $customerMobile', AppColors.green),
              _infoRow(Icons.location_on_outlined, customerAddress, AppColors.orange),
            ]),
            const SizedBox(height: 12),

            // Order info
            _infoCard('Order Details', [
              _infoRow(Icons.local_laundry_service_outlined, 'Service: $serviceType', AppColors.accent),
              _infoRow(Icons.category_outlined, 'Type: ${orderType.toUpperCase()}', AppColors.accent2),
              _infoRow(Icons.calendar_today_outlined, 'Created: $createdDate', AppColors.textSub),
              _infoRow(Icons.event_available_outlined, 'Expected: $expectedDate', AppColors.textSub),
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
                  ...garments.map((g) {
                    final name = g['name'] as String? ?? 'Item';
                    final qty = g['qty'] as num? ?? 1;
                    final rate = g['rate'] as num? ?? 40;
                    return _garmentRow(name, qty.toInt(), rate.toInt());
                  }).toList(),
                  const Divider(height: 1),
                  _totalRow('Subtotal', '₹$subtotal'),
                  if (deliveryCharge > 0)
                    _totalRow('Delivery Charge', '₹$deliveryCharge'),
                  _totalRow('Total', '₹$totalAmount', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Payment status
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isPaid
                    ? AppColors.green.withOpacity(0.08)
                    : AppColors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isPaid
                        ? AppColors.green.withOpacity(0.3)
                        : AppColors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                      isPaid ? Icons.check_circle : Icons.error_outline,
                      color: isPaid ? AppColors.green : AppColors.red),
                  const SizedBox(width: 10),
                  Text(
                      isPaid ? 'Payment: PAID — ₹$totalAmount' : 'Payment: UNPAID — ₹$totalAmount',
                      style: TextStyle(
                          color: isPaid ? AppColors.green : AppColors.red,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            AppButton(
              label: 'Update Status',
              onTap: () async {
                await context.push('/orders/${widget.orderId}/status');
                _loadOrder(); // Reload order after status update
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'View Invoice',
              onTap: () =>
                  context.push('/invoices/${widget.orderId}'),
              color: AppColors.accent2,
            ),
            if (!isPaid) ...[
              const SizedBox(height: 10),
              AppButton(
                label: 'Collect Payment',
                onTap: () async {
                  await context.push('/collect-payment');
                  _loadOrder();
                },
                color: AppColors.gold,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusTimeline(String status) {
    final statusIdxMap = {
      'received': 0,
      'washing': 1,
      'ironing': 2,
      'ready': 3,
      'delivered': 4,
    };
    final currentIdx = statusIdxMap[status.toLowerCase()] ?? 0;

    final steps = [
      {'label': 'Received', 'val': 0},
      {'label': 'Washing', 'val': 1},
      {'label': 'Ironing', 'val': 2},
      {'label': 'Ready', 'val': 3},
      {'label': 'Delivered', 'val': 4},
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
              final val = step['val'] as int;
              final done = val <= currentIdx;
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