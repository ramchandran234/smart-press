// lib/features/reports/screens/receivables_screen.dart
// PPT Screen 36 — Outstanding Receivables Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  State<ReceivablesScreen> createState() =>
      _ReceivablesScreenState();
}

class _ReceivablesScreenState
    extends State<ReceivablesScreen> {
  String _filter = 'All';
  final _filters = ['All', '7+ Days', '15+ Days', '30+ Days'];

  final _receivables = [
    {'name': 'Priya Sharma', 'amount': 340,
      'days': 1, 'orders': 'ORD001'},
    {'name': 'Anita Singh', 'amount': 560,
      'days': 4, 'orders': 'ORD003'},
    {'name': 'Deepa Nair', 'amount': 420,
      'days': 8, 'orders': 'ORD005'},
    {'name': 'Kiran Patel', 'amount': 280,
      'days': 18, 'orders': 'ORD006'},
    {'name': 'Mohan Das', 'amount': 160,
      'days': 32, 'orders': 'ORD009'},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _receivables.where((r) {
      final days = r['days'] as int;
      if (_filter == '7+ Days') return days >= 7;
      if (_filter == '15+ Days') return days >= 15;
      if (_filter == '30+ Days') return days >= 30;
      return true;
    }).cast<Map<String, dynamic>>().toList();
  }

  int get _total =>
      _filtered.fold(0, (s, r) => s + (r['amount'] as int));

  Color _daysColor(int days) {
    if (days >= 30) return AppColors.red;
    if (days >= 15) return AppColors.orange;
    if (days >= 7) return AppColors.gold;
    return AppColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outstanding Receivables'),
        actions: [
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Total outstanding
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.darkBg,
            child: Column(
              children: [
                const Text('Total Outstanding',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text('₹$_total',
                    style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
                Text('${_filtered.length} customers',
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12)),
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
                            ? AppColors.red
                            : AppColors.bgLight,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.red
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
                final r = _filtered[i];
                final days = r['days'] as int;
                final color = _daysColor(days);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              color.withOpacity(0.12),
                          child: Text(
                            (r['name'] as String)[0],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(r['name'] as String,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              Text(
                                  '${r['orders']}  •  $days days overdue',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight:
                                          FontWeight.w600)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text('₹${r['amount']}',
                                style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.red)),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.green
                                      .withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(
                                          8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.chat,
                                        size: 12,
                                        color:
                                            AppColors.green),
                                    SizedBox(width: 3),
                                    Text('Remind',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors
                                                .green,
                                            fontWeight:
                                                FontWeight
                                                    .bold)),
                                  ],
                                ),
                              ),
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
}