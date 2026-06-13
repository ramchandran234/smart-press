// lib/features/suppliers/screens/supplier_list_screen.dart
// PPT Screen 26 — Supplier List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() =>
      _SupplierListScreenState();
}

class _SupplierListScreenState
    extends State<SupplierListScreen> {
  String _filter = 'All';
  final _filters = [
    'All', 'Detergent', 'Transport', 'Equipment', 'Other'
  ];

  final _suppliers = [
    {'id': 'S001', 'name': 'Rajan Chemicals',
      'category': 'Detergent', 'balance': 2400,
      'lastPaid': '01 May', 'phone': '+91 98765 11111'},
    {'id': 'S002', 'name': 'Fast Courier Co',
      'category': 'Transport', 'balance': 0,
      'lastPaid': '03 May', 'phone': '+91 87654 22222'},
    {'id': 'S003', 'name': 'Clean Supply Hub',
      'category': 'Detergent', 'balance': 1800,
      'lastPaid': '28 Apr', 'phone': '+91 76543 33333'},
    {'id': 'S004', 'name': 'Iron Parts Store',
      'category': 'Equipment', 'balance': 0,
      'lastPaid': '25 Apr', 'phone': '+91 65432 44444'},
    {'id': 'S005', 'name': 'Quick Delivery',
      'category': 'Transport', 'balance': 600,
      'lastPaid': '20 Apr', 'phone': '+91 54321 55555'},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _suppliers.where((s) {
      if (_filter == 'All') return true;
      return s['category'] == _filter;
    }).cast<Map<String, dynamic>>().toList();
  }

  int get _totalOutstanding => _suppliers.fold(
      0, (sum, s) => sum + (s['balance'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/suppliers/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Outstanding summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkBg, AppColors.accent2],
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _topStat('Total Suppliers',
                    '${_suppliers.length}', AppColors.white),
                Container(
                    width: 1, height: 40,
                    color: Colors.white24),
                _topStat('Total Outstanding',
                    '₹$_totalOutstanding', AppColors.gold),
                Container(
                    width: 1, height: 40,
                    color: Colors.white24),
                _topStat('Cleared',
                    '${_suppliers.where((s) => s['balance'] == 0).length}',
                    AppColors.green),
              ],
            ),
          ),

          // Filter chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final sel = _filter == f;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin:
                          const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.gold
                            : AppColors.bgLight,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.gold
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
                final s = _filtered[i];
                final hasBalance =
                    (s['balance'] as int) > 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context
                        .push('/suppliers/${s['id']}'),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.gold
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.store,
                                color: AppColors.gold,
                                size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(s['name'] as String,
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 15)),
                                Text(
                                    '${s['category']}  •  Last paid: ${s['lastPaid']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            AppColors.textSub)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              if (hasBalance) ...[
                                Text(
                                    '₹${s['balance']}',
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.red)),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.red
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: const Text('Due',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.red,
                                          fontWeight:
                                              FontWeight.bold)),
                                ),
                              ] else ...[
                                const Icon(Icons.check_circle,
                                    color: AppColors.green,
                                    size: 22),
                                const Text('Cleared',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.green,
                                        fontWeight:
                                            FontWeight.bold)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/suppliers/new'),
        backgroundColor: AppColors.gold,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('Add Supplier',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _topStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}