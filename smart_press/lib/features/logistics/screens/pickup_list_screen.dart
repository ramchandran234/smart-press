// lib/features/logistics/screens/pickup_list_screen.dart
// PPT Screen 14 — Pickup List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class PickupListScreen extends StatefulWidget {
  const PickupListScreen({super.key});

  @override
  State<PickupListScreen> createState() =>
      _PickupListScreenState();
}

class _PickupListScreenState extends State<PickupListScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Pending', 'On the Way', 'Done'];

  final _pickups = [
    {'name': 'Priya Sharma', 'address': 'Koramangala 4th Block',
      'time': '9:00 AM', 'items': '5 items', 'status': 'Pending',
      'phone': '+91 98765 43210', 'orderId': 'ORD001'},
    {'name': 'Ravi Kumar', 'address': 'Indiranagar 100 Feet Rd',
      'time': '10:30 AM', 'items': '3 items', 'status': 'On the Way',
      'phone': '+91 87654 32109', 'orderId': 'ORD002'},
    {'name': 'Deepa Nair', 'address': 'Jayanagar 4th Block',
      'time': '12:00 PM', 'items': '6 items', 'status': 'Done',
      'phone': '+91 76543 21098', 'orderId': 'ORD003'},
    {'name': 'Kiran Patel', 'address': 'BTM Layout Stage 2',
      'time': '2:00 PM', 'items': '4 items', 'status': 'Pending',
      'phone': '+91 65432 10987', 'orderId': 'ORD004'},
    {'name': 'Meena Iyer', 'address': 'HSR Layout Sec 7',
      'time': '4:30 PM', 'items': '8 items', 'status': 'Pending',
      'phone': '+91 54321 09876', 'orderId': 'ORD005'},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Done': return AppColors.green;
      case 'On the Way': return AppColors.accent;
      default: return AppColors.orange;
    }
  }

  List get _filtered => _filter == 'All'
      ? _pickups
      : _pickups.where((p) => p['status'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/schedule-slot'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Row(
              children: [
                _summaryChip('${_pickups.length} Total',
                    AppColors.accent),
                const SizedBox(width: 8),
                _summaryChip(
                    '${_pickups.where((p) => p['status'] == 'Pending').length} Pending',
                    AppColors.orange),
                const SizedBox(width: 8),
                _summaryChip(
                    '${_pickups.where((p) => p['status'] == 'Done').length} Done',
                    AppColors.green),
              ],
            ),
          ),

          // Filter chips
          Container(
            color: AppColors.bgLight,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final sel = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.orange
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.orange
                                : AppColors.cardBorder),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? AppColors.white
                                  : AppColors.textSub)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final p = _filtered[i];
                final color = _statusColor(p['status']!);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color:
                                    color.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                  Icons.local_shipping_outlined,
                                  color: color,
                                  size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(p['name']!,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 15)),
                                  Text(p['address']!,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              AppColors.textSub)),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(p['status']!,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight:
                                          FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14,
                                color: AppColors.textSub),
                            const SizedBox(width: 4),
                            Text(p['time']!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: color,
                                    fontWeight:
                                        FontWeight.bold)),
                            const SizedBox(width: 16),
                            Icon(Icons.checkroom,
                                size: 14,
                                color: AppColors.textSub),
                            const SizedBox(width: 4),
                            Text(p['items']!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSub)),
                            const Spacer(),
                            // Call button
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call,
                                  color: AppColors.green,
                                  size: 20),
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            // View order
                            IconButton(
                              onPressed: () => context.push(
                                  '/orders/${p['orderId']}'),
                              icon: const Icon(
                                  Icons.receipt_long,
                                  color: AppColors.accent2,
                                  size: 20),
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            // Mark done
                            if (p['status'] != 'Done')
                              ElevatedButton(
                                onPressed: () => setState(() =>
                                    p['status'] = 'Done'),
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.green,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6),
                                  minimumSize: Size.zero,
                                  textStyle: const TextStyle(
                                      fontSize: 11),
                                ),
                                child:
                                    const Text('Picked Up'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold)),
    );
  }
}