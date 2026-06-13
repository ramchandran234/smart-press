// lib/features/customer/screens/payment_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = [
      {'id': 'PAY001', 'order': 'ORD091',
        'amount': '₹480', 'date': '28 Apr 2026',
        'mode': 'UPI', 'status': 'Success'},
      {'id': 'PAY002', 'order': 'ORD082',
        'amount': '₹180', 'date': '15 Apr 2026',
        'mode': 'Card', 'status': 'Success'},
      {'id': 'PAY003', 'order': 'ORD074',
        'amount': '₹360', 'date': '01 Apr 2026',
        'mode': 'UPI', 'status': 'Failed'},
      {'id': 'PAY004', 'order': 'ORD065',
        'amount': '₹220', 'date': '20 Mar 2026',
        'mode': 'Cash', 'status': 'Success'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Payment History'),
        actions: [
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.darkBg,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _stat('Total Paid', '₹1,240',
                    AppColors.green),
                _stat('Transactions', '4',
                    AppColors.accent),
                _stat('Failed', '1', AppColors.red),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (_, i) {
                final p = payments[i];
                final success =
                    (p['status'] ?? '') == 'Success';
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => context
                        .push('/invoices/${p['order']}'),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: success
                            ? AppColors.green
                                .withOpacity(0.12)
                            : AppColors.red.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Icon(
                        success
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: success
                            ? AppColors.green
                            : AppColors.red,
                      ),
                    ),
                    title: Text(p['amount'] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    subtitle: Text(
                        '${p['order'] ?? ''}  •  '
                        '${p['mode'] ?? ''}  •  '
                        '${p['date'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSub)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: success
                            ? AppColors.green
                                .withOpacity(0.12)
                            : AppColors.red.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                          (p['status'] ?? '').toUpperCase(),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: success
                                  ? AppColors.green
                                  : AppColors.red)),
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

  Widget _stat(String label, String value, Color color) {
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