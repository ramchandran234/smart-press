// lib/features/expenses/screens/expense_list_screen.dart
// PPT Screen 31 — Expense List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() =>
      _ExpenseListScreenState();
}

class _ExpenseListScreenState
    extends State<ExpenseListScreen> {
  String _category = 'All';
  final _categories = [
    'All', 'Detergent', 'Transport',
    'Equipment', 'Salary', 'Other'
  ];

  final _expenses = [
    {'id': 'EXP001', 'desc': 'Detergent Stock',
      'category': 'Detergent', 'amount': 1200,
      'date': '05 May', 'supplier': 'Rajan Chemicals',
      'mode': 'UPI'},
    {'id': 'EXP002', 'desc': 'Delivery Charges',
      'category': 'Transport', 'amount': 400,
      'date': '04 May', 'supplier': 'Fast Courier',
      'mode': 'Cash'},
    {'id': 'EXP003', 'desc': 'Iron Replacement',
      'category': 'Equipment', 'amount': 2500,
      'date': '03 May', 'supplier': 'Iron Parts Store',
      'mode': 'UPI'},
    {'id': 'EXP004', 'desc': 'Staff Salary',
      'category': 'Salary', 'amount': 8000,
      'date': '01 May', 'supplier': '',
      'mode': 'Cash'},
    {'id': 'EXP005', 'desc': 'Fabric Softener',
      'category': 'Detergent', 'amount': 600,
      'date': '28 Apr', 'supplier': 'Clean Supply Hub',
      'mode': 'UPI'},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _expenses.where((e) {
      if (_category == 'All') return true;
      return e['category'] == _category;
    }).cast<Map<String, dynamic>>().toList();
  }

  int get _total =>
      _filtered.fold(0, (s, e) => s + (e['amount'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.darkBg,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _stat('This Month', '₹12,700',
                    AppColors.white),
                Container(
                    width: 1, height: 36,
                    color: Colors.white24),
                _stat('Filtered Total', '₹$_total',
                    AppColors.gold),
                Container(
                    width: 1, height: 36,
                    color: Colors.white24),
                _stat('Transactions',
                    '${_filtered.length}', AppColors.accent),
              ],
            ),
          ),

          // Category filter
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final sel = _category == cat;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin:
                          const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.orange
                            : AppColors.bgLight,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.orange
                                : AppColors.cardBorder),
                      ),
                      child: Text(cat,
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
                final e = _filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.orange
                            .withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long,
                          color: AppColors.orange, size: 22),
                    ),
                    title: Text(e['desc'] as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${e['category']}  •  ${e['date']}  •  ${e['mode']}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSub)),
                    trailing: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        Text('₹${e['amount']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.red)),
                        if ((e['supplier'] as String)
                            .isNotEmpty)
                          Text(e['supplier'] as String,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSub)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/new'),
        backgroundColor: AppColors.orange,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text('Add Expense',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}