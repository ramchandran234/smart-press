// lib/features/suppliers/screens/supplier_qr_screen.dart
// PPT Screen 29 — Show Supplier QR Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SupplierQrScreen extends StatelessWidget {
  final String supplierId;
  const SupplierQrScreen(
      {super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Supplier QR — Pay Now'),
        actions: [
          IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {}),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Rajan Chemicals',
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Scan to Pay via UPI',
              style: TextStyle(
                  color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 32),

          // QR
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.gold.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5),
              ],
            ),
            child: const Center(
              child: Icon(Icons.qr_code,
                  size: 210, color: AppColors.darkBg),
            ),
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
                Text('rajanchemicals@upi',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Outstanding amount
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.red.withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_outlined,
                    color: AppColors.gold, size: 18),
                SizedBox(width: 8),
                Text('Outstanding: ₹2,400',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text('Scan with GPay / PhonePe / Any UPI App',
              style: TextStyle(
                  color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}