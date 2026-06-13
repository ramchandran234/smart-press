// lib/features/suppliers/screens/record_payment_screen.dart
// PPT Screen 30 — Record Supplier Payment Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class RecordPaymentScreen extends StatefulWidget {
  final String supplierId;
  const RecordPaymentScreen(
      {super.key, required this.supplierId});

  @override
  State<RecordPaymentScreen> createState() =>
      _RecordPaymentScreenState();
}

class _RecordPaymentScreenState
    extends State<RecordPaymentScreen> {
  String _mode = 'UPI';
  final _modes = ['UPI', 'Cash', 'Cheque', 'Bank Transfer'];
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Record Supplier Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.2),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text('Outstanding: ₹2,400',
                            style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _label('Amount Paid (₹)'),
            const SizedBox(height: 8),
            const AppTextField(
              label: '',
              hint: 'Enter amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            _label('Payment Mode'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modes.map((m) {
                final sel = _mode == m;
                return GestureDetector(
                  onTap: () => setState(() => _mode = m),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.gold
                          : AppColors.white,
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: sel
                              ? AppColors.gold
                              : AppColors.cardBorder),
                    ),
                    child: Text(m,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: sel
                                ? AppColors.white
                                : AppColors.textSub)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _label('Payment Date'),
            const SizedBox(height: 8),
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
                        color: AppColors.accent2, size: 20),
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
            const SizedBox(height: 20),

            // Screenshot upload
            _label('Payment Screenshot (Optional)'),
            const SizedBox(height: 8),
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
                      color: AppColors.accent
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: AppColors.accent),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Attach Screenshot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text('Camera or Gallery',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  const Icon(Icons.upload_rounded,
                      color: AppColors.accent),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Reference Number (Optional)',
              hint: 'UPI Ref / Cheque No',
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Notes (Optional)',
              hint: 'Add any notes...',
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Save Payment Record',
              color: AppColors.gold,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment recorded!'),
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

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.textDark));
}