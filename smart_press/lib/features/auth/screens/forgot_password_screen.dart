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
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _otpSent = false;

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

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Enter a valid email address', AppColors.red);
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService.sendPasswordResetOtp(email: email);
    setState(() => _loading = false);

    if (result['success'] == true) {
      _showSnack('OTP sent to your email!', AppColors.green);
      setState(() => _otpSent = true);
    } else {
      _showSnack(result['error'] ?? 'Failed to send OTP', AppColors.red);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (otp.isEmpty) {
      _showSnack('Enter the OTP received on your email', AppColors.red);
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
    final result = await AuthService.resetPassword(
      email: email,
      otp: otp,
      password: password,
    );
    setState(() => _loading = false);

    if (result['success'] == true) {
      _showSnack('Password reset successful! Please login.', AppColors.green);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      context.go('/login?role=${widget.role}');
    } else {
      _showSnack(result['error'] ?? 'Reset failed', AppColors.red);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
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
            Text(
              _otpSent 
                ? 'Enter the OTP sent to your email and set a new password.'
                : 'Enter your registered email address to receive an OTP.',
              style: const TextStyle(color: AppColors.textSub, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            AppTextField(
              label: 'Email Address',
              hint: 'e.g. user@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            
            if (_otpSent) ...[
              AppTextField(
                label: 'OTP',
                hint: 'Enter 6-digit OTP',
                controller: _otpController,
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
            ],

            _loading
                ? Center(
                    child: CircularProgressIndicator(color: color),
                  )
                : AppButton(
                    label: _otpSent ? 'Reset Password' : 'Send OTP',
                    color: color,
                    onTap: _otpSent ? _resetPassword : _sendOtp,
                  ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

