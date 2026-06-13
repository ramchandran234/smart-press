// lib/features/suppliers/screens/add_supplier_screen.dart
// PPT Screen 27 — Add New Supplier Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() =>
      _AddSupplierScreenState();
}

class _AddSupplierScreenState
    extends State<AddSupplierScreen> {
  String _category = 'Detergent';
  final _categories = [
    'Detergent', 'Transport', 'Equipment',
    'Packaging', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Supplier')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Basic Details'),
            const SizedBox(height: 12),
            const AppTextField(
                label: 'Supplier Name',
                hint: 'Enter supplier / shop name'),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                  labelText: 'Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(
                      value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _category = v!),
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Mobile Number',
              hint: '+91 XXXXXXXXXX',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Business Address',
              hint: 'Enter full address',
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            _sectionLabel('Payment Details'),
            const SizedBox(height: 12),
            const AppTextField(
              label: 'UPI ID',
              hint: 'supplier@upi',
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Bank Account (Optional)',
              hint: 'Account number',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'IFSC Code (Optional)',
              hint: 'SBIN0001234',
            ),
            const SizedBox(height: 14),

            // Upload QR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code,
                        color: AppColors.gold),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Upload Supplier QR Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text('GPay / PhonePe / UPI QR',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  Icon(Icons.upload_rounded,
                      color: AppColors.gold),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _sectionLabel('Opening Balance'),
            const SizedBox(height: 12),
            const AppTextField(
              label: 'Opening Balance (₹)',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Save Supplier',
              color: AppColors.gold,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Supplier added successfully!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textDark)),
      ],
    );
  }
}