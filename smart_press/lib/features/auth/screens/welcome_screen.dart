// lib/features/auth/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 28),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color:
                      AppColors.accent.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.accent,
                      width: 2.5),
                ),
                child: const Icon(Icons.iron,
                    size: 52, color: AppColors.accent),
              ),
              const SizedBox(height: 24),
              const Text('Smart Press',
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 1)),
              const SizedBox(height: 8),
              const Text(
                  'Professional Laundry Management',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.accent)),
              const SizedBox(height: 6),
              const Text(
                  'Owner • Customer • All in one',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSub)),
              const SizedBox(height: 50),

              // ── OWNER SECTION ─────────────────────
              _sectionLabel('FOR SHOP OWNERS'),
              const SizedBox(height: 10),
              AppButton(
                label: '🏪  Owner Login',
                onTap: () =>
                    context.push('/otp?role=owner'),
                color: AppColors.accent,
              ),
              const SizedBox(height: 10),
              AppButton(
                label: '📝  New Owner Registration',
                onTap: () => context.push('/register'),
                color: AppColors.accent2,
                outline: true,
              ),
              const SizedBox(height: 30),

              // Divider
              Row(children: [
                const Expanded(
                    child: Divider(
                        color: AppColors.textSub)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12),
                  child: Text('OR',
                      style: TextStyle(
                          color: AppColors.textSub
                              .withOpacity(0.7),
                          fontSize: 12)),
                ),
                const Expanded(
                    child: Divider(
                        color: AppColors.textSub)),
              ]),
              const SizedBox(height: 30),

              // ── CUSTOMER SECTION ──────────────────
              _sectionLabel('FOR CUSTOMERS'),
              const SizedBox(height: 10),
              AppButton(
                label: '👤  Customer Login',
                onTap: () => context
                    .push('/otp?role=customer'),
                color: AppColors.green,
              ),
              const SizedBox(height: 10),
              AppButton(
                label: '✨  New Customer Registration',
                onTap: () =>
                    context.push('/customer-register'),
                color: AppColors.green,
                outline: true,
              ),
              const SizedBox(height: 40),

              const Text('v1.0  •  Terms & Privacy',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSub)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSub,
              letterSpacing: 1.5)),
    );
  }
}