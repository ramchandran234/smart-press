// lib/features/customers/screens/customer_list_screen.dart
// PPT Screen 17 — Customer List Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/customer_service.dart';

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

  List<dynamic> _customers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final res = await CustomerService.getCustomers(search: _search);
      if (res['success'] == true) {
        if (mounted) {
          setState(() {
            _customers = res['customers'] as List<dynamic>;
            _loading = false;
          });
        }
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> get _filtered {
    return _customers.where((c) {
      final active = c['isActive'] ?? true;
      final matchFilter = _filter == 'All' ||
          (_filter == 'Active' && active == true) ||
          (_filter == 'Inactive' && active == false);
      return matchFilter;
    }).toList();
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'None';
    try {
      final dt = DateTime.parse(isoString);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (e) {
      return 'None';
    }
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
              onChanged: (v) {
                setState(() {
                  _search = v;
                  _loading = true;
                });
                _fetchCustomers();
              },
              decoration: InputDecoration(
                hintText: 'Search by name or mobile...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.accent2),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _search = '';
                            _loading = true;
                          });
                          _fetchCustomers();
                        },
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
                    '₹${_customers.fold<int>(0, (s, c) => s + ((c['balance'] as num? ?? 0).toInt()))}',
                    AppColors.red),
                _stat(
                    'Active',
                    '${_customers.where((c) => (c['isActive'] ?? true) == true).length}',
                    AppColors.green),
              ],
            ),
          ),

          // Customer list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : _filtered.isEmpty
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
                    : RefreshIndicator(
                        onRefresh: _fetchCustomers,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) =>
                              _customerCard(_filtered[i]),
                        ),
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
    final balance = (c['balance'] as num? ?? 0).toInt();
    final hasBalance = balance > 0;
    final active = c['isActive'] ?? true;
    final name = c['name'] as String? ?? 'N/A';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.push('/customers/${c['_id']}'),
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
                  name.isNotEmpty ? name[0].toUpperCase() : 'C',
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
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(width: 6),
                        if (!active)
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
                    Text(c['mobile'] as String? ?? '',
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
                          '${c['totalOrders'] ?? 0} orders  •  Last: ${_formatDate(c['lastOrderAt'] as String?)}',
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
                      Text('₹$balance',
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