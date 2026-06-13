// lib/features/settings/screens/upload_qr_screen.dart
// PPT Screen 40 — Upload Owner QR Code Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class UploadQrScreen extends StatefulWidget {
  const UploadQrScreen({super.key});

  @override
  State<UploadQrScreen> createState() =>
      _UploadQrScreenState();
}

class _UploadQrScreenState extends State<UploadQrScreen> {
  bool _hasQr = true;
  String _upiLabel = 'GPay';
  final _upiOptions = ['GPay', 'PhonePe', 'Paytm', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Payment QR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.gold, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This QR is shown to customers when collecting payment',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current QR preview
            const Text('Current QR Code',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _hasQr
                          ? AppColors.green
                          : AppColors.cardBorder,
                      width: 2),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10)
                  ],
                ),
                child: _hasQr
                    ? Stack(
                        children: [
                          const Center(
                            child: Icon(Icons.qr_code,
                                size: 150,
                                color: AppColors.darkBg),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: const Text('Active',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate,
                              size: 60,
                              color: AppColors.cardBorder),
                          SizedBox(height: 8),
                          Text('No QR uploaded',
                              style: TextStyle(
                                  color: AppColors.textSub)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // UPI label
            const Text('UPI App Label',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _upiOptions.map((u) {
                final sel = _upiLabel == u;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _upiLabel = u),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.gold
                          : AppColors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                          color: sel
                              ? AppColors.gold
                              : AppColors.cardBorder),
                    ),
                    child: Text(u,
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

            // UPI ID field
            TextFormField(
              initialValue: 'smartpress@upi',
              decoration: const InputDecoration(
                labelText: 'UPI ID',
                prefixIcon: Icon(Icons.account_balance_wallet,
                    color: AppColors.gold),
              ),
            ),
            const SizedBox(height: 24),

            // Upload buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _hasQr = true),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(
                          color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _hasQr = true),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent2,
                      side: const BorderSide(
                          color: AppColors.accent2),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save & Set as Active QR',
              color: AppColors.gold,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR code updated!'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.pop();
              },
            ),
            if (_hasQr) ...[
              const SizedBox(height: 10),
              AppButton(
                label: 'Delete QR',
                color: AppColors.red,
                onTap: () =>
                    setState(() => _hasQr = false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}