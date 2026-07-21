import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String role;
  const ForgotPasswordScreen({super.key, required this.role});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;

  void _showSnack(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
  }

  Future<void> _resetPassword() async {
    final mobile = _mobileController.text.trim();
    final pin = _pinController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (mobile.isEmpty) {
      _showSnack('Enter your mobile number', AppColors.red);
      return;
    }
    if (pin.isEmpty || pin.length < 6) {
      _showSnack('Enter your 6-digit Recovery PIN', AppColors.red);
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

    setState(() => _loading = true);
    final result = await AuthService.resetPasswordWithPin(
      mobile: mobile,
      recoveryPin: pin,
      newPassword: password,
    );
    setState(() => _loading = false);

    if (result['success'] == true) {
      _showSnack('Password reset successful! Please login.', AppColors.green);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      context.go('/otp?role=${widget.role}');
    } else {
      _showSnack(result['error'] ?? 'Reset failed', AppColors.red);
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.role == 'owner' ? AppColors.accent : AppColors.green;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Forgot Password',
            style: TextStyle(color: AppColors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reset your password',
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Enter your registered mobile number and the 6-digit Recovery PIN you received during registration.',
              style: TextStyle(color: AppColors.textSub, fontSize: 14),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Mobile Number',
              hint: '+91 XXXXXXXXXX',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Recovery PIN',
              hint: 'Enter 6-digit PIN',
              controller: _pinController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'New Password',
              hint: 'Enter new password',
              controller: _passwordController,
              obscure: true,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Confirm Password',
              hint: 'Confirm new password',
              controller: _confirmPasswordController,
              obscure: true,
            ),
            const SizedBox(height: 28),
            _loading
                ? Center(
                    child: CircularProgressIndicator(color: color),
                  )
                : AppButton(
                    label: 'Reset Password',
                    color: color,
                    onTap: _resetPassword,
                  ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
