// lib/features/orders/screens/create_order_screen.dart
// PPT Screen 8 — Create New Order Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() =>
      _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String _orderType = 'Walk-in';
  String _serviceType = 'Wash + Iron';
  final List<String> _orderTypes = ['Walk-in', 'Pickup', 'Delivery'];
  final List<String> _serviceTypes = [
    'Wash + Iron', 'Dry Clean', 'Iron Only', 'Wash Only'
  ];

  final List<Map<String, dynamic>> _garments = [
    {'name': 'Shirt', 'qty': 2, 'price': 40},
    {'name': 'Trouser', 'qty': 1, 'price': 50},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer section
            _sectionTitle('Customer Details'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.highlight,
                    child: Icon(Icons.person_outline,
                        color: AppColors.accent2),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Priya Sharma',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text('+91 98765 43210',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Change')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order type
            _sectionTitle('Order Type'),
            const SizedBox(height: 10),
            Row(
              children: _orderTypes.map((t) {
                final sel = _orderType == t;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _orderType = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.accent
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Text(t,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: sel
                                  ? AppColors.white
                                  : AppColors.textSub)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Service type
            _sectionTitle('Service Type'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _serviceType,
              decoration: const InputDecoration(),
              items: _serviceTypes
                  .map((s) => DropdownMenuItem(
                      value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _serviceType = v!),
            ),
            const SizedBox(height: 20),

            // Garments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Garments'),
                TextButton.icon(
                  onPressed: () => _addGarmentDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._garments.asMap().entries.map((e) =>
                _garmentRow(e.key, e.value)),
            const SizedBox(height: 20),

            // Date
            _sectionTitle('Expected Delivery Date'),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now()
                      .add(const Duration(days: 2)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 30)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.cardBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppColors.accent2, size: 20),
                    SizedBox(width: 10),
                    Text('07 May 2026',
                        style: TextStyle(
                            fontWeight: FontWeight.w500)),
                    Spacer(),
                    Icon(Icons.arrow_drop_down,
                        color: AppColors.textSub),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            const AppTextField(
              label: 'Special Instructions',
              hint: 'e.g. Handle with care, no bleach...',
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Amount summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _amountRow('Subtotal', '₹130'),
                  _amountRow('Delivery Charge', '₹40'),
                  const Divider(color: Colors.white24),
                  _amountRow('Total', '₹170', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save Order & Print QR',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order created successfully!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.pop();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textDark));

  Widget _garmentRow(int index, Map<String, dynamic> g) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(g['name'],
                style: const TextStyle(
                    fontWeight: FontWeight.w600)),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline,
                    color: AppColors.red, size: 20),
                onPressed: () => setState(() {
                  if (g['qty'] > 1) g['qty']--;
                }),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${g['qty']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.green, size: 20),
                onPressed: () =>
                    setState(() => g['qty']++),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text('₹${g['price'] * g['qty']}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent2)),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.red, size: 18),
            onPressed: () =>
                setState(() => _garments.removeAt(index)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, String value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: bold ? AppColors.white : Colors.white70,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: bold ? AppColors.gold : AppColors.white,
                  fontWeight: bold
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: bold ? 16 : 14)),
        ],
      ),
    );
  }

  void _addGarmentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Garment',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...[
              'Shirt', 'Trouser', 'Saree', 'Kurta',
              'Bedsheet', 'Towel', 'Jacket'
            ].map((g) => ListTile(
                  leading: const Icon(Icons.checkroom,
                      color: AppColors.accent),
                  title: Text(g),
                  onTap: () {
                    setState(() => _garments.add(
                        {'name': g, 'qty': 1, 'price': 40}));
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}