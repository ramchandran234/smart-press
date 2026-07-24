// lib/features/customer/screens/vendor_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class VendorPaymentScreen extends StatefulWidget {
  const VendorPaymentScreen({super.key});

  @override
  State<VendorPaymentScreen> createState() =>
      _VendorPaymentScreenState();
}

class _VendorPaymentScreenState extends State<VendorPaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Pay Vendor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Vendor + amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.darkBg,
                    AppColors.accent2
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store,
                          color: Colors.white70, size: 18),
                      SizedBox(width: 6),
                      Text('Smart Press',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('₹ 240',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Vendor Order — ORD001',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Spacer(),
            const Icon(Icons.info_outline, size: 48, color: AppColors.textSub),
            const SizedBox(height: 16),
            const Text(
              'Please complete the payment directly with the shop owner (Cash or Online). The owner will close the order once payment is received.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSub, fontSize: 14, height: 1.5),
            ),
            const Spacer(),



            const Spacer(),
            AppButton(
              label: 'Return to Dashboard',
              color: AppColors.accent,
              onTap: () {
                context.go('/customer/dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }
}