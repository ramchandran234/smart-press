// lib/features/payments/screens/owner_qr_screen.dart
// PPT Screen 22 — Show Owner QR Code Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OwnerQrScreen extends StatelessWidget {
  const OwnerQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Payment QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Smart Press',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Scan to Pay via UPI',
              style: TextStyle(
                  color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 32),

          // QR Code
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.qr_code,
                    size: 220, color: AppColors.darkBg),
                // Center logo
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.iron,
                      color: AppColors.white, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // UPI options
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _upiChip('GPay', Icons.g_mobiledata),
              const SizedBox(width: 12),
              _upiChip('PhonePe', Icons.phone_android),
              const SizedBox(width: 12),
              _upiChip('Paytm', Icons.account_balance_wallet),
              const SizedBox(width: 12),
              _upiChip('Any UPI', Icons.qr_code_scanner),
            ],
          ),
          const SizedBox(height: 24),

          // UPI ID
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.white.withOpacity(0.2)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.copy_outlined,
                    color: Colors.white60, size: 16),
                SizedBox(width: 8),
                Text('smartpress@upi',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 40),

          const Text(
              'Keep this screen visible to the customer',
              style: TextStyle(
                  color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _upiChip(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.white.withOpacity(0.2)),
          ),
          child: Icon(icon,
              color: AppColors.white, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}