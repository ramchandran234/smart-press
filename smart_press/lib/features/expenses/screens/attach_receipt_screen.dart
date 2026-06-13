// lib/features/expenses/screens/attach_receipt_screen.dart
// PPT Screen 33 — Attach Receipt Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class AttachReceiptScreen extends StatefulWidget {
  const AttachReceiptScreen({super.key});

  @override
  State<AttachReceiptScreen> createState() =>
      _AttachReceiptScreenState();
}

class _AttachReceiptScreenState
    extends State<AttachReceiptScreen> {
  bool _hasImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Attach Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview area
            GestureDetector(
              onTap: () =>
                  setState(() => _hasImage = true),
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _hasImage
                          ? AppColors.green
                          : AppColors.cardBorder,
                      width: _hasImage ? 2 : 1),
                ),
                child: _hasImage
                    ? Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.highlight,
                              borderRadius:
                                  BorderRadius.circular(
                                      16),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      Icons
                                          .receipt_long,
                                      size: 80,
                                      color: AppColors
                                          .accent2),
                                  SizedBox(height: 10),
                                  Text(
                                      'Receipt Preview',
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: AppColors
                                              .accent2)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _hasImage = false),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.close,
                                    color: AppColors.white,
                                    size: 18),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius:
                                    BorderRadius.circular(
                                        8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check,
                                      color: AppColors.white,
                                      size: 14),
                                  SizedBox(width: 4),
                                  Text('Good Quality',
                                      style: TextStyle(
                                          color:
                                              AppColors.white,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 64,
                              color: AppColors.cardBorder),
                          SizedBox(height: 12),
                          Text('Tap to capture receipt',
                              style: TextStyle(
                                  color: AppColors.textSub,
                                  fontSize: 14)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Source options
            Row(
              children: [
                Expanded(
                  child: _sourceButton(
                    Icons.camera_alt,
                    'Camera',
                    AppColors.accent,
                    () => setState(() => _hasImage = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _sourceButton(
                    Icons.photo_library,
                    'Gallery',
                    AppColors.accent2,
                    () => setState(() => _hasImage = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // OCR hint
            if (_hasImage)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          AppColors.accent.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_fix_high,
                        color: AppColors.accent, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Amount detected: ₹1,200  •  Tap to auto-fill',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.accent2,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            AppButton(
              label: _hasImage
                  ? 'Confirm & Attach'
                  : 'Select Image First',
              color: _hasImage
                  ? AppColors.green
                  : AppColors.textSub,
              onTap: () {
                if (_hasImage) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text('Receipt attached!'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                  context.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sourceButton(IconData icon, String label,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }
}