// lib/features/customers/screens/customer_list_screen.dart
// PPT Screen 17 — Customer List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() =>
      _CustomerListScreenState();
}

class _CustomerListScreenState
    extends State<CustomerListScreen> {
  String _search = '';
  String _filter = 'All';
  final _filters = ['All', 'Active', 'Inactive'];

  final _customers = [
    {'id': 'C001', 'name': 'Priya Sharma',
      'mobile': '+91 98765 43210', 'orders': 12,
      'balance': 340, 'lastOrder': '05 May',
      'active': true},
    {'id': 'C002', 'name': 'Raj Kumar',
      'mobile': '+91 87654 32109', 'orders': 8,
      'balance': 0, 'lastOrder': '04 May',
      'active': true},
    {'id': 'C003', 'name': 'Anita Singh',
      'mobile': '+91 76543 21098', 'orders': 23,
      'balance': 0, 'lastOrder': '03 May',
      'active': true},
    {'id': 'C004', 'name': 'Suresh Babu',
      'mobile': '+91 65432 10987', 'orders': 5,
      'balance': 220, 'lastOrder': '01 May',
      'active': false},
    {'id': 'C005', 'name': 'Deepa Nair',
      'mobile': '+91 54321 09876', 'orders': 17,
      'balance': 0, 'lastOrder': '02 May',
      'active': true},
    {'id': 'C006', 'name': 'Kiran Patel',
      'mobile': '+91 43210 98765', 'orders': 3,
      'balance': 160, 'lastOrder': '28 Apr',
      'active': true},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _customers.where((c) {
      final matchSearch = _search.isEmpty ||
          (c['name'] as String)
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          (c['mobile'] as String).contains(_search);
      final matchFilter = _filter == 'All' ||
          (_filter == 'Active' && c['active'] == true) ||
          (_filter == 'Inactive' && c['active'] == false);
      return matchSearch && matchFilter;
    }).cast<Map<String, dynamic>>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Customers'),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                16, 12, 16, 8),
            child: TextField(
              onChanged: (v) =>
                  setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by name or mobile...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.accent2),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () =>
                            setState(() => _search = ''),
                      )
                    : null,
              ),
            ),
          ),

          // Filter chips
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                12, 0, 12, 10),
            child: Row(
              children: _filters.map((f) {
                final sel = _filter == f;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.accent
                          : AppColors.bgLight,
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                          color: sel
                              ? AppColors.accent
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

          // Summary
          Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _stat('Total',
                    '${_customers.length}',
                    AppColors.accent),
                _stat(
                    'Outstanding',
                    '₹${_customers.fold(0, (s, c) => s + (c['balance'] as int))}',
                    AppColors.red),
                _stat(
                    'Active',
                    '${_customers.where((c) => c['active'] == true).length}',
                    AppColors.green),
              ],
            ),
          ),

          // Customer list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64,
                            color: AppColors.cardBorder),
                        SizedBox(height: 12),
                        Text('No customers found',
                            style: TextStyle(
                                color: AppColors.textSub)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) =>
                        _customerCard(_filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/customers/new'),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.person_add,
            color: AppColors.white),
        label: const Text('Add Customer',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _bottomNav(context, 2),
    );
  }

  Widget _customerCard(Map<String, dynamic> c) {
    final hasBalance = (c['balance'] as int) > 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.push('/customers/${c['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    AppColors.accent.withOpacity(0.15),
                child: Text(
                  (c['name'] as String)[0],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent2),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c['name'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(width: 6),
                        if (!(c['active'] as bool))
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.textSub
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                            child: const Text('Inactive',
                                style: TextStyle(
                                    fontSize: 9,
                                    color:
                                        AppColors.textSub)),
                          ),
                      ],
                    ),
                    Text(c['mobile'] as String,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSub)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.receipt_long,
                          size: 12,
                          color: AppColors.accent2),
                      const SizedBox(width: 3),
                      Text(
                          '${c['orders']} orders  •  Last: ${c['lastOrder']}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSub)),
                    ]),
                  ],
                ),
              ),
              // Balance badge
              if (hasBalance)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color:
                            AppColors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text('Due',
                          style: TextStyle(
                              fontSize: 9,
                              color: AppColors.red)),
                      Text('₹${c['balance']}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.red)),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right,
                  color: AppColors.cardBorder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
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

  Widget _bottomNav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people), label: 'Customers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reports'),
      ],
      onTap: (i) {
        const routes = [
          '/home', '/orders',
          '/customers', '/reports/revenue'
        ];
        context.go(routes[i]);
      },
    );
  }
}