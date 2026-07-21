// lib/features/customer/screens/customer_order_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';
import '../../../shared/widgets/app_button.dart';

class CustomerOrderDetailScreen extends StatefulWidget {
  final String orderId;
  const CustomerOrderDetailScreen({super.key, required this.orderId});

  @override
  State<CustomerOrderDetailScreen> createState() => _CustomerOrderDetailScreenState();
}

class _CustomerOrderDetailScreenState extends State<CustomerOrderDetailScreen> {
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'received': return AppColors.accent;
      case 'washing':
      case 'ironing': return AppColors.orange;
      case 'ready': return AppColors.green;
      case 'delivered': return AppColors.textSub;
      case 'cancelled': return AppColors.red;
      default: return AppColors.accent;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'received': return 'Order Received';
      case 'washing': return 'Washing in Progress';
      case 'ironing': return 'Ironing in Progress';
      case 'ready': return 'Ready for Delivery';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return 'Order Received';
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

    final status = _order!['status'] as String? ?? 'received';
    final color = _getStatusColor(status);
    final shop = _order!['owner'] as Map<String, dynamic>?;
    final shopName = shop != null ? shop['shopName'] as String? ?? shop['name'] as String? ?? 'Laundry Shop' : 'Laundry Shop';
    final shopMobile = shop != null ? shop['mobile'] as String? ?? '' : '';
    
    final shopAddressLine1 = shop != null ? shop['addressLine1'] as String? ?? shop['address'] as String? ?? '' : '';
    final shopArea = shop != null ? shop['area'] as String? ?? '' : '';
    final shopCity = shop != null ? shop['city'] as String? ?? '' : '';
    final shopAddressList = [shopAddressLine1, shopArea, shopCity].where((s) => s.isNotEmpty).toList();
    final shopAddress = shopAddressList.isNotEmpty ? shopAddressList.join(', ') : 'Not provided';

    final garments = _order!['garments'] as List<dynamic>? ?? [];
    final subtotal = _order!['subtotal'] as num? ?? 0;
    final deliveryCharge = _order!['deliveryCharge'] as num? ?? 0;
    final totalAmount = _order!['totalAmount'] as num? ?? 0;
    final isPaid = _order!['isPaid'] as bool? ?? false;

    final expectedAtStr = _order!['expectedDate'] as String? ?? '';
    final expectedDate = expectedAtStr.isNotEmpty 
        ? expectedAtStr.substring(0, 10) 
        : 'Flexible';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text('Order ${_order!['orderId'] ?? widget.orderId}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrder,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          Icons.local_laundry_service,
                          color: color,
                          size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(_getStatusText(status),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: color)),
                          Text('Expected: $expectedDate',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSub)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context.push('/customer/order-progress/${widget.orderId}');
                        _loadOrder(); // reload when coming back
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
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
                _row(Icons.store, shopName, AppColors.accent2),
                _row(Icons.location_on_outlined, shopAddress, AppColors.orange),
                if (shopMobile.isNotEmpty)
                  _row(Icons.phone_outlined, '+91 $shopMobile', AppColors.green),
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
                    ...garments.map((g) {
                      final name = g['name'] as String? ?? 'Item';
                      final qty = g['qty'] as num? ?? 1;
                      final rate = g['rate'] as num? ?? 40;
                      return _garmentRow(name, qty.toInt(), rate.toInt());
                    }).toList(),
                    const Divider(height: 1),
                    _totalRow('Subtotal', '₹$subtotal'),
                    if (deliveryCharge > 0)
                      _totalRow('Delivery', '₹$deliveryCharge'),
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
                        isPaid ? Icons.check_circle_outline : Icons.payment,
                        color: isPaid ? AppColors.green : AppColors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          isPaid ? 'Payment Received — ₹$totalAmount' : 'Payment Pending — ₹$totalAmount',
                          style: TextStyle(
                              color: isPaid ? AppColors.green : AppColors.red,
                              fontWeight: FontWeight.bold)),
                    ),
                    if (!isPaid)
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
                    context.push('/invoices/${widget.orderId}'),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Track Order',
                color: color,
                onTap: () async {
                  await context.push('/customer/order-progress/${widget.orderId}');
                  _loadOrder();
                },
              ),
            ],
          ),
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