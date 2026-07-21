// lib/features/auth/screens/owner_register_screen.dart
// PPT Screen 3 — Owner Registration Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class OwnerRegisterScreen extends StatefulWidget {
  const OwnerRegisterScreen({super.key});

  @override
  State<OwnerRegisterScreen> createState() =>
      _OwnerRegisterScreenState();
}

class _OwnerRegisterScreenState extends State<OwnerRegisterScreen> {
  final _nameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRecoveryDialog(String recoveryPin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.vpn_key, color: AppColors.accent2),
              SizedBox(width: 10),
              Text('Save Your Recovery PIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please save this 6-digit PIN securely. You will need it to reset your password if you ever forget it.',
                style: TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: SelectableText(
                    recoveryPin,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/otp?role=owner');
              },
              child: const Text('OK, Copied PIN', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent2)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final shopName = _shopNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || shopName.isEmpty || mobile.isEmpty || password.isEmpty) {
      _showSnack('Please fill all required fields', AppColors.red);
      return;
    }
    if (mobile.length < 10) {
      _showSnack('Enter a valid mobile number', AppColors.red);
      return;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', AppColors.red);
      return;
    }
    if (password != confirmPassword) {
      _showSnack('Passwords do not match', AppColors.red);
      return;
    }
    if (!_acceptTerms) {
      _showSnack('Please accept the terms and conditions', AppColors.red);
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.register(
      name: name,
      mobile: mobile,
      password: password,
      role: 'owner',
      extra: {
        'shopName': shopName,
      },
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result['success'] == true) {
      await AuthService.logout();
      if (!mounted) return;
      final user = result['user'] as Map<String, dynamic>?;
      final recoveryPin = user?['recoveryPin'] as String? ?? '000000';
      _showRecoveryDialog(recoveryPin);
    } else {
      _showSnack(result['error'] ?? 'Registration failed', AppColors.red);
    }
  }

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
            AppTextField(
                key: const Key('reg_fullname'),
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: _nameController),
            const SizedBox(height: 16),
            AppTextField(
                key: const Key('reg_shopname'),
                label: 'Shop Name',
                hint: 'Enter your shop name',
                controller: _shopNameController),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('reg_mobile'),
              label: 'Mobile Number',
              hint: '+91 XXXXXXXXXX',
              keyboardType: TextInputType.phone,
              controller: _mobileController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('reg_password'),
              label: 'Password',
              hint: '••••••••',
              obscure: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm Password',
              hint: '••••••••',
              obscure: true,
              controller: _confirmPasswordController,
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
              key: const Key('reg_submit_btn'),
              label: _isLoading ? 'Creating account...' : 'Register & Continue',
              onTap: _isLoading ? () {} : () { _register(); },
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