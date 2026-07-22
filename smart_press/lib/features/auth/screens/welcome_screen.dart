// lib/features/auth/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _warmUpBackend();
  }

  void _warmUpBackend() async {
    try {
      await http.get(Uri.parse(AppConfig.baseUrl.replaceAll('/api', ''))).timeout(const Duration(seconds: 45));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Glowing Neon Logo Badge
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.35),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.iron, size: 54, color: AppColors.accent),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Iron Buddy',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '✨ Next-Gen Laundry Suite',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Owner • Customer • Instant Geolocation',
                  style: TextStyle(fontSize: 12, color: AppColors.textSub),
                ),
                const SizedBox(height: 48),

                // ── OWNER SECTION ─────────────────────
                _sectionLabel('SHOP OWNER PORTAL'),
                const SizedBox(height: 12),
                AppButton(
                  key: const Key('owner_login_btn'),
                  label: '🏪  Owner Login',
                  icon: Icons.storefront,
                  onTap: () => context.push('/otp?role=owner'),
                  color: AppColors.accent,
                ),
                const SizedBox(height: 12),
                AppButton(
                  key: const Key('owner_register_btn'),
                  label: '📝  Register New Shop',
                  icon: Icons.app_registration,
                  onTap: () => context.push('/register'),
                  color: AppColors.accent2,
                  outline: true,
                ),
                const SizedBox(height: 32),

                // Glowing Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.cardBorder.withOpacity(0.4))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR',
                        style: TextStyle(color: AppColors.textSub.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.cardBorder.withOpacity(0.4))),
                  ],
                ),
                const SizedBox(height: 32),

                // ── CUSTOMER SECTION ──────────────────
                _sectionLabel('CUSTOMER PORTAL'),
                const SizedBox(height: 12),
                AppButton(
                  key: const Key('customer_login_btn'),
                  label: '👤  Customer Login',
                  icon: Icons.person_outline,
                  onTap: () => context.push('/otp?role=customer'),
                  color: AppColors.green,
                ),
                const SizedBox(height: 12),
                AppButton(
                  key: const Key('customer_register_btn'),
                  label: '✨  Create Customer Account',
                  icon: Icons.person_add_alt_1_outlined,
                  onTap: () => context.push('/customer-register'),
                  color: AppColors.green,
                  outline: true,
                ),
                const SizedBox(height: 48),

                const Text(
                  'Iron Buddy v2.0 • Powered by Smart Press',
                  style: TextStyle(fontSize: 11, color: AppColors.textSub),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}