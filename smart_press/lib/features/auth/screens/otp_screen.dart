// lib/features/auth/screens/otp_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  final String role;
  const OtpScreen({super.key, required this.role});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _serverReady = false;

  @override
  void initState() {
    super.initState();
    _wakeUpServer();
  }

  Future<void> _wakeUpServer() async {
    try {
      await http.get(
        Uri.parse(AppConfig.baseUrl.replaceAll('/api', '')),
      ).timeout(const Duration(seconds: 60));
      if (mounted) setState(() => _serverReady = true);
    } catch (e) {
      if (mounted) setState(() => _serverReady = true);
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ));
  }

  Future<void> _login() async {
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text.trim();

    if (mobile.isEmpty) {
      _snack('Enter your mobile number', AppColors.red);
      return;
    }
    if (password.isEmpty) {
      _snack('Enter your password', AppColors.red);
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService.login(
      mobile: mobile,
      password: password,
      role: widget.role,
    );
    setState(() => _loading = false);

    if (result['success'] == true) {
      _snack('Login successful!', AppColors.green);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (widget.role == 'owner') {
        context.go('/home');
      } else {
        context.go('/customer/dashboard');
      }
    } else {
      _snack(result['error'] ?? 'Invalid credentials', AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.role == 'owner';
    final color   = isOwner ? AppColors.accent : AppColors.green;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isOwner ? 'Owner Login' : 'Customer Login',
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Server status banner
            if (!_serverReady)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.gold.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withAlpha((0.4 * 255).round())),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.gold),
                    ),
                    SizedBox(width: 10),
                    Text('Connecting to server...',
                        style: TextStyle(color: AppColors.gold, fontSize: 12)),
                  ],
                ),
              ),

            // Icon
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: color.withAlpha((0.15 * 255).round()),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                isOwner ? Icons.store : Icons.person,
                size: 38, color: color,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isOwner ? 'Owner Verification' : 'Customer Verification',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            const SizedBox(height: 10),

            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: color.withAlpha((0.15 * 255).round()),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha((0.4 * 255).round())),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isOwner ? Icons.store : Icons.person_outline,
                      size: 14, color: color),
                  const SizedBox(width: 6),
                  Text(
                    isOwner ? 'Logging in as Owner' : 'Logging in as Customer',
                    style: TextStyle(
                        fontSize: 12, color: color, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Mobile Number',
                  style: TextStyle(
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('mobile_field'),
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: '+91 XXXXXXXXXX',
                hintStyle: const TextStyle(color: AppColors.textSub),
                filled: true,
                fillColor: AppColors.accent2.withAlpha((0.15 * 255).round()),
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.accent),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gold, width: 2)),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Password',
                  style: TextStyle(
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('password_field'),
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: AppColors.textSub),
                filled: true,
                fillColor: AppColors.accent2.withAlpha((0.15 * 255).round()),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.accent),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gold, width: 2)),
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? CircularProgressIndicator(color: color)
                : AppButton(
                    key: const Key('login_btn'),
                    label: 'Login',
                    color: color,
                    onTap: _login,
                  ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Forgot Password?',
              color: color,
              outline: true,
              onTap: () => context.pushNamed(
                'forgot-password',
                queryParameters: {'role': widget.role},
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

}