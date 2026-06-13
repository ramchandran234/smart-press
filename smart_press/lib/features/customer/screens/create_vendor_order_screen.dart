// lib/features/customer/screens/create_vendor_order_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class CreateVendorOrderScreen extends StatefulWidget {
  const CreateVendorOrderScreen({super.key});

  @override
  State<CreateVendorOrderScreen> createState() =>
      _CreateVendorOrderScreenState();
}

class _CreateVendorOrderScreenState
    extends State<CreateVendorOrderScreen> {
  String _service = 'Wash + Iron';
  final _services = [
    'Wash + Iron', 'Dry Clean', 'Iron Only', 'Wash Only'
  ];

  final List<Map<String, dynamic>> _garments = [
    {'name': 'Shirt', 'qty': 2},
    {'name': 'Trouser', 'qty': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Create Vendor Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected vendor
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.accent
                        .withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.store,
                      color: AppColors.accent, size: 28),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text('Smart Press',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text(
                          'Koramangala  •  0.3 km  •  ⭐ 4.8',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSub)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Service type
            _label('Service Type'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _service,
              decoration: const InputDecoration(),
              items: _services
                  .map((s) => DropdownMenuItem(
                      value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _service = v!),
            ),
            const SizedBox(height: 20),

            // Garments
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _label('Garments'),
                TextButton.icon(
                  onPressed: () => setState(() =>
                      _garments.add(
                          {'name': 'Item', 'qty': 1})),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._garments.asMap().entries.map((e) {
              final i = e.key;
              final g = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(g['name'],
                            style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600))),
                    IconButton(
                      icon: const Icon(
                          Icons.remove_circle_outline,
                          color: AppColors.red,
                          size: 20),
                      onPressed: () => setState(() {
                        if (g['qty'] > 1) g['qty']--;
                      }),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10),
                      child: Text('${g['qty']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.add_circle_outline,
                          color: AppColors.green,
                          size: 20),
                      onPressed: () =>
                          setState(() => g['qty']++),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.red,
                          size: 18),
                      onPressed: () => setState(
                          () => _garments.removeAt(i)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Pickup mode
            _label('Pickup Mode'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping,
                      color: AppColors.green),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Home Pickup',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold)),
                        Text(
                            'Koramangala 4th Block',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context
                        .push('/customer/delivery-mode'),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amount estimate
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Total',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14)),
                  Text(
                      '₹${_garments.fold(0, (s, g) => s + (g['qty'] as int) * 40)}',
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Place Vendor Order',
              color: AppColors.accent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Order placed successfully!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.go('/customer/orders');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textDark));
}