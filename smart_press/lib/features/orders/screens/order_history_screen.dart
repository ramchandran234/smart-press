// lib/features/orders/screens/order_history_screen.dart
// PPT Screen 12 — Order History Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _dateRange;

  final _history = [
    {'id': 'ORD091', 'name': 'Meena Iyer', 'status': 'Delivered',
      'amount': '₹480', 'date': '03 May 2026', 'items': 8},
    {'id': 'ORD090', 'name': 'Vijay Menon', 'status': 'Delivered',
      'amount': '₹220', 'date': '02 May 2026', 'items': 4},
    {'id': 'ORD089', 'name': 'Saranya K', 'status': 'Cancelled',
      'amount': '₹160', 'date': '01 May 2026', 'items': 3},
    {'id': 'ORD088', 'name': 'Ramu Pillai', 'status': 'Delivered',
      'amount': '₹640', 'date': '30 Apr 2026', 'items': 12},
    {'id': 'ORD087', 'name': 'Divya S', 'status': 'Delivered',
      'amount': '₹300', 'date': '29 Apr 2026', 'items': 6},
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );
              if (range != null) {
                setState(() => _dateRange = range);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Exporting to CSV...'),
                    backgroundColor: AppColors.accent2),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Total Orders', '48',
                    AppColors.accent),
                _summaryItem('Revenue', '₹18,240',
                    AppColors.green),
                _summaryItem('Cancelled', '3',
                    AppColors.red),
              ],
            ),
          ),
          // List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_history
                    .where((o) => o['status'] == 'Delivered')
                    .toList()),
                _buildList(_history
                    .where((o) => o['status'] == 'Cancelled')
                    .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSub)),
      ],
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final o = list[i];
        final delivered = o['status'] == 'Delivered';
        final color =
            delivered ? AppColors.green : AppColors.red;
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            onTap: () => context.push('/orders/${o['id']}'),
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                delivered ? Icons.done_all : Icons.cancel_outlined,
                color: color, size: 20),
            ),
            title: Text(o['name'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
            subtitle: Text(
                '${o['id']}  •  ${o['items']} items  •  ${o['date']}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSub)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(o['amount'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(o['status'],
                      style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}