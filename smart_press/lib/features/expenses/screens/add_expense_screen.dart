// lib/features/expenses/screens/add_expense_screen.dart
// PPT Screen 32 — Add Expense Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _category = 'Detergent';
  String _mode = 'UPI';
  bool _attachReceipt = false;
  DateTime _date = DateTime.now();

  final _categories = [
    'Detergent', 'Transport', 'Equipment',
    'Salary', 'Rent', 'Other'
  ];
  final _modes = ['UPI', 'Cash', 'Cheque'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier (optional)
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          AppColors.gold.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store,
                        color: AppColors.gold),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Rajan Chemicals',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text('Tap to change supplier',
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
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _category,
              decoration:
                  const InputDecoration(labelText: 'Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(
                      value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _category = v!),
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Amount (₹)',
              hint: 'Enter amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            // Payment mode
            const Text('Payment Mode',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: _modes.map((m) {
                final sel = _mode == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _mode = m),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.orange
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                            color: sel
                                ? AppColors.orange
                                : AppColors.cardBorder),
                      ),
                      child: Text(m,
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
            const SizedBox(height: 14),

            // Date
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.accent2, size: 18),
                    const SizedBox(width: 10),
                    Text(
                        '${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.textSub),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Description',
              hint: 'e.g. Monthly detergent stock...',
              maxLines: 2,
            ),
            const SizedBox(height: 14),

            // Receipt toggle
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
                  const Icon(Icons.camera_alt,
                      color: AppColors.accent2),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Attach Receipt',
                        style: TextStyle(
                            fontWeight: FontWeight.w600)),
                  ),
                  Switch(
                    value: _attachReceipt,
                    activeColor: AppColors.orange,
                    onChanged: (v) => setState(
                        () => _attachReceipt = v),
                  ),
                ],
              ),
            ),
            if (_attachReceipt) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/expenses/receipt'),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Open Camera / Gallery'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.orange),
                    foregroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: 'Save Expense',
              color: AppColors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Expense saved successfully!'),
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
}