// lib/features/auth/screens/owner_register_screen.dart
// PPT Screen 3 — Owner Registration Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class OwnerRegisterScreen extends StatefulWidget {
  const OwnerRegisterScreen({super.key});

  @override
  State<OwnerRegisterScreen> createState() =>
      _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends State<OwnerRegisterScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkBg, AppColors.accent2],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Your Account',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white)),
                  SizedBox(height: 4),
                  Text('Fill in your shop details to get started',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const AppTextField(
                label: 'Full Name',
                hint: 'Enter your full name'),
            const SizedBox(height: 16),
            const AppTextField(
                label: 'Shop Name',
                hint: 'Enter your shop name'),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Mobile Number',
              hint: '+91 XXXXXXXXXX',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Email (Optional)',
              hint: 'email@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Password',
              hint: '••••••••',
              obscure: true,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Confirm Password',
              hint: '••••••••',
              obscure: true,
            ),
            const SizedBox(height: 16),
            // Terms checkbox
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: AppColors.accent,
                  onChanged: (v) =>
                      setState(() => _acceptTerms = v ?? false),
                ),
                const Expanded(
                  child: Text(
                    'I accept the Terms & Conditions',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Register & Continue',
              onTap: () => context.push('/verify'),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: AppColors.accent2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}