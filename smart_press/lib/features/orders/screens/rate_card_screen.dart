// lib/features/orders/screens/rate_card_screen.dart
// PPT Screen 13 — Rate Card Editor Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class RateCardScreen extends StatefulWidget {
  const RateCardScreen({super.key});

  @override
  State<RateCardScreen> createState() => _RateCardScreenState();
}

class _RateCardScreenState extends State<RateCardScreen> {
  final List<Map<String, dynamic>> _rates = [
    {'name': 'Shirt', 'wash': 30, 'iron': 15, 'dryclean': 80},
    {'name': 'Trouser', 'wash': 40, 'iron': 20, 'dryclean': 100},
    {'name': 'Saree', 'wash': 60, 'iron': 30, 'dryclean': 150},
    {'name': 'Kurta', 'wash': 35, 'iron': 15, 'dryclean': 90},
    {'name': 'Bedsheet', 'wash': 80, 'iron': 40, 'dryclean': 200},
    {'name': 'Towel', 'wash': 25, 'iron': 10, 'dryclean': 60},
    {'name': 'Jacket', 'wash': 100, 'iron': 40, 'dryclean': 250},
  ];

  int _deliveryCharge = 40;
  int _expressCharge = 20;
  int _minOrder = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Card Editor'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Rate card saved!'),
                    backgroundColor: AppColors.green),
              );
            },
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.accent.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.accent, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'These prices auto-apply when creating new orders',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.accent2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Garment Prices',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textDark)),
            const SizedBox(height: 10),

            // Table header
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
              ),
              child: const Row(
                children: [
                  Expanded(
                      child: Text('Item',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                      width: 60,
                      child: Text('Wash',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                      width: 60,
                      child: Text('Iron',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                      width: 70,
                      child: Text('Dry Clean',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Garment rows
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12)),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: _rates.asMap().entries.map((e) {
                  final i = e.key;
                  final r = e.value;
                  return Container(
                    color: i % 2 == 0
                        ? AppColors.white
                        : AppColors.highlight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(r['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                        _priceField(r['wash'], (v) =>
                            setState(() => r['wash'] = v)),
                        _priceField(r['iron'], (v) =>
                            setState(() => r['iron'] = v)),
                        _priceField(r['dryclean'], (v) =>
                            setState(() => r['dryclean'] = v),
                            width: 70),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Charges & Limits',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            _chargeRow('Delivery Charge (₹)', _deliveryCharge,
                (v) => setState(() => _deliveryCharge = v)),
            const SizedBox(height: 10),
            _chargeRow('Express Surcharge (₹)', _expressCharge,
                (v) => setState(() => _expressCharge = v)),
            const SizedBox(height: 10),
            _chargeRow('Minimum Order (₹)', _minOrder,
                (v) => setState(() => _minOrder = v)),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save Rate Card',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Rate card updated!'),
                      backgroundColor: AppColors.green),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceField(int value, Function(int) onChanged,
      {double width = 60}) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: value.toString(),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 4, vertical: 6),
          border: OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (v) =>
            onChanged(int.tryParse(v) ?? value),
      ),
    );
  }

  Widget _chargeRow(
      String label, int value, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: value.toString(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent2),
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) =>
                  onChanged(int.tryParse(v) ?? value),
            ),
          ),
        ],
      ),
    );
  }
}