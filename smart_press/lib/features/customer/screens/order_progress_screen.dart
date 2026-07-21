// lib/features/customer/screens/order_progress_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

class CustomerOrderProgressScreen extends StatefulWidget {
  final String orderId;
  const CustomerOrderProgressScreen(
      {super.key, required this.orderId});

  @override
  State<CustomerOrderProgressScreen> createState() => _CustomerOrderProgressScreenState();
}

class _CustomerOrderProgressScreenState extends State<CustomerOrderProgressScreen> {
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

  double _getProgressValue(String status) {
    switch (status.toLowerCase()) {
      case 'received': return 0.20;
      case 'washing': return 0.40;
      case 'ironing': return 0.60;
      case 'ready': return 0.80;
      case 'delivered': return 1.0;
      default: return 0.20;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'received': return '🫧 Order Received';
      case 'washing': return '🫧 Washing in Progress';
      case 'ironing': return '🫧 Ironing in Progress';
      case 'ready': return '✨ Ready for Collection';
      case 'delivered': return '✅ Order Delivered';
      case 'cancelled': return '❌ Order Cancelled';
      default: return 'Order Received';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Track — ${widget.orderId}')),
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Track — ${widget.orderId}')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final status = _order!['status'] as String? ?? 'received';
    final shop = _order!['owner'] as Map<String, dynamic>?;
    final shopName = shop != null ? shop['shopName'] as String? ?? shop['name'] as String? ?? 'Laundry Shop' : 'Laundry Shop';
    
    final garments = _order!['garments'] as List<dynamic>? ?? [];
    final garmentCount = garments.fold(0, (s, g) => s + (g['qty'] as num? ?? 1).toInt());
    final totalAmount = _order!['totalAmount'] as num? ?? 0;

    final expectedAtStr = _order!['expectedDate'] as String? ?? '';
    final expectedDate = expectedAtStr.isNotEmpty 
        ? expectedAtStr.substring(0, 10) 
        : 'Flexible';

    final statusIdxMap = {
      'received': 0,
      'washing': 1,
      'ironing': 2,
      'ready': 3,
      'delivered': 4,
    };
    final currentIdx = statusIdxMap[status.toLowerCase()] ?? 0;

    final steps = [
      {'label': 'Order Received', 'icon': Icons.inbox, 'val': 0},
      {'label': 'Washing', 'icon': Icons.local_laundry_service, 'val': 1},
      {'label': 'Ironing', 'icon': Icons.iron, 'val': 2},
      {'label': 'Ready for Delivery', 'icon': Icons.check_circle_outline, 'val': 3},
      {'label': 'Delivered', 'icon': Icons.done_all, 'val': 4},
    ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: Text('Track — ${_order!['orderId'] ?? widget.orderId}'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrder,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.accent2,
                      AppColors.accent
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Current Status',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(_getStatusText(status),
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _getProgressValue(status),
                        backgroundColor:
                            Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation(
                                AppColors.gold),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Step ${currentIdx + 1} of 5',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11)),
                        Text('${(_getProgressValue(status) * 100).toInt()}% Complete',
                            style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Order Timeline',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 16),

              // Timeline steps
              ...steps.asMap().entries.map((e) {
                final i = e.key;
                final step = e.value;
                final val = step['val'] as int;
                final done = val <= currentIdx;
                final isLast = i == steps.length - 1;
                return Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: done
                                ? AppColors.green
                                : AppColors.cardBorder,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: done
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 20,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: done
                                ? AppColors.green
                                : AppColors.cardBorder,
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(step['label'] as String,
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 14,
                                    color: done
                                        ? AppColors.textDark
                                        : AppColors.textSub)),
                            Text(done ? 'Completed' : 'Pending',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: done
                                        ? AppColors.green
                                        : AppColors.textSub)),
                            if (!isLast)
                              const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    if (done)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Icon(Icons.check_circle,
                            color: AppColors.green,
                            size: 18),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Order info card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _infoRow('Order ID', _order!['orderId'] as String? ?? widget.orderId),
                    _infoRow('Shop', shopName),
                    _infoRow('Items', '$garmentCount garments'),
                    _infoRow('Amount', '₹$totalAmount'),
                    _infoRow(
                        'Est. Delivery', expectedDate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}