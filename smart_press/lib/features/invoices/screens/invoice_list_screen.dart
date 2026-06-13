// lib/features/invoices/screens/invoice_list_screen.dart
// PPT Screen 24 — Invoice List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() =>
      _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _invoices = [
    {'id': 'INV001', 'customer': 'Priya Sharma',
      'amount': '₹340', 'date': '05 May', 'paid': false,
      'due': '07 May', 'overdue': false},
    {'id': 'INV002', 'customer': 'Raj Kumar',
      'amount': '₹180', 'date': '04 May', 'paid': true,
      'due': '06 May', 'overdue': false},
    {'id': 'INV003', 'customer': 'Anita Singh',
      'amount': '₹560', 'date': '01 May', 'paid': false,
      'due': '03 May', 'overdue': true},
    {'id': 'INV004', 'customer': 'Suresh Babu',
      'amount': '₹220', 'date': '03 May', 'paid': true,
      'due': '05 May', 'overdue': false},
    {'id': 'INV005', 'customer': 'Deepa Nair',
      'amount': '₹420', 'date': '28 Apr', 'paid': false,
      'due': '30 Apr', 'overdue': true},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unpaid =
        _invoices.where((i) => i['paid'] == false).toList();
    final paid =
        _invoices.where((i) => i['paid'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'Unpaid (${unpaid.length})'),
            Tab(text: 'Paid (${paid.length})'),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Summary
          Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _stat('Total Unpaid',
                    '₹${unpaid.fold(0, (s, i) => s + int.parse((i['amount'] as String).replaceAll('₹', '')))}',
                    AppColors.red),
                _stat('Overdue',
                    '${unpaid.where((i) => i['overdue'] == true).length}',
                    AppColors.orange),
                _stat('Paid This Month', '₹${paid.fold(0, (s, i) => s + int.parse((i['amount'] as String).replaceAll('₹', '')))}',
                    AppColors.green),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(unpaid),
                _buildList(paid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final inv = list[i] as Map<String, dynamic>;
        final paid = inv['paid'] as bool;
        final overdue = inv['overdue'] as bool;
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                context.push('/invoices/${inv['id']}'),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: paid
                          ? AppColors.green.withOpacity(0.1)
                          : overdue
                              ? AppColors.red
                                  .withOpacity(0.1)
                              : AppColors.orange
                                  .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      paid
                          ? Icons.receipt
                          : Icons.receipt_long,
                      color: paid
                          ? AppColors.green
                          : overdue
                              ? AppColors.red
                              : AppColors.orange,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(inv['customer'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(
                            '${inv['id']}  •  ${inv['date']}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSub)),
                        if (overdue && !paid)
                          Text(
                              'Overdue since ${inv['due']}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.red,
                                  fontWeight:
                                      FontWeight.bold)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(inv['amount'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: paid
                              ? AppColors.green
                                  .withOpacity(0.12)
                              : overdue
                                  ? AppColors.red
                                      .withOpacity(0.12)
                                  : AppColors.orange
                                      .withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          paid
                              ? 'Paid'
                              : overdue
                                  ? 'Overdue'
                                  : 'Unpaid',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: paid
                                  ? AppColors.green
                                  : overdue
                                      ? AppColors.red
                                      : AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSub)),
      ],
    );
  }
}