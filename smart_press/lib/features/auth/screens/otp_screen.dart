// lib/features/auth/screens/otp_screen.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../core/config/app_config.dart';

class OtpScreen extends StatefulWidget {
  final String role;
  const OtpScreen({super.key, required this.role});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  int _seconds   = 60;
  Timer? _timer;
  bool _otpSent  = false;
  bool _loading  = false;
  String _devOtp = '';
  bool _serverReady = false;

  static const String _base = AppConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    _wakeUpServer();
  }

  // ── Wake up Render server ──────────────────────────
  Future<void> _wakeUpServer() async {
    try {
      print('⏳ Waking up server...');
      await http.get(
        Uri.parse('https://smart-press-backend.onrender.com'),
      ).timeout(const Duration(seconds: 60));
      if (mounted) setState(() => _serverReady = true);
      print('✅ Server is awake!');
    } catch (e) {
      print('⚠️ Server wake up: $e');
      if (mounted) setState(() => _serverReady = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_seconds == 0) { t.cancel(); return; }
      setState(() => _seconds--);
    });
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

  Future<Map<String, dynamic>> _apiCall(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      print('📡 Calling: $_base$endpoint');
      print('📦 Body: ${jsonEncode(body)}');
      final response = await http
          .post(
            Uri.parse('$_base$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 60));
      print('📨 Status: ${response.statusCode}');
      print('📨 Body: ${response.body}');
      final data = jsonDecode(response.body);
      return data as Map<String, dynamic>;
    } catch (e) {
      print('❌ API Error: $e');
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timed out')) {
        return {
          'success': false,
          'error': 'Server is waking up. Please try again in 10 seconds.',
        };
      }
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<void> _sendOtp() async {
    final mobile = _mobileController.text.trim();
    if (mobile.isEmpty) {
      _snack('Enter your mobile number', AppColors.red);
      return;
    }
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      _snack('Enter valid 10-digit mobile number', AppColors.red);
      return;
    }
    setState(() => _loading = true);
    final result = await _apiCall(
      '/auth/send-otp',
      {'mobile': mobile, 'role': widget.role},
    );
    setState(() => _loading = false);
    if (result['success'] == true) {
      setState(() {
        _otpSent = true;
        _devOtp  = result['otp']?.toString() ?? '';
      });
      _startTimer();
      _snack('✅ OTP sent to $mobile', AppColors.green);
    } else {
      _snack(result['error'] ?? 'Failed to send OTP', AppColors.red);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text.trim()).join();
    if (otp.length < 6) {
      _snack('Enter complete 6-digit OTP', AppColors.red);
      return;
    }
    setState(() => _loading = true);
    final result = await _apiCall(
      '/auth/verify-otp',
      {
        'mobile': _mobileController.text.trim(),
        'otp':    otp,
        'role':   widget.role,
      },
    );
    setState(() => _loading = false);
    if (result['success'] == true) {
      _snack('✅ Login successful!', AppColors.green);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (widget.role == 'owner') {
        context.go('/home');
      } else {
        context.go('/customer/dashboard');
      }
    } else {
      _snack(result['error'] ?? 'Invalid OTP', AppColors.red);
    }
  }

  void _resendOtp() {
    for (var c in _otpControllers) c.clear();
    setState(() {
      _otpSent = false;
      _devOtp  = '';
    });
    _sendOtp();
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

            // ── Server status banner ──────────────────
            if (!_serverReady)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.gold.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.gold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '⏳ Connecting to server...',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),

            // ── Icon ──────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(
                isOwner ? Icons.store : Icons.person,
                size: 38,
                color: color,
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ─────────────────────────────────
            Text(
              isOwner ? 'Owner Verification' : 'Customer Verification',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            const SizedBox(height: 10),

            // ── Role badge ────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOwner ? Icons.store : Icons.person_outline,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOwner ? 'Logging in as Owner' : 'Logging in as Customer',
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Mobile input ──────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Mobile Number',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              enabled: !_otpSent,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: '+91 XXXXXXXXXX',
                hintStyle: const TextStyle(color: AppColors.textSub),
                filled: true,
                fillColor: AppColors.accent2.withOpacity(0.15),
                prefixIcon: const Icon(
                    Icons.phone_outlined, color: AppColors.accent),
                suffixIcon: _otpSent
                    ? IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.gold, size: 18),
                        onPressed: () => setState(() {
                          _otpSent = false;
                          _devOtp  = '';
                          for (var c in _otpControllers) c.clear();
                        }),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.gold, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Send OTP button ───────────────────────
            if (!_otpSent)
              _loading
                  ? CircularProgressIndicator(color: color)
                  : AppButton(
                      label: 'Send OTP 📨',
                      color: color,
                      onTap: _sendOtp,
                    ),

            // ── OTP section ───────────────────────────
            if (_otpSent) ...[
              // Dev OTP box
              if (_devOtp.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.gold.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key,
                              color: AppColors.gold, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Development Mode — Your OTP',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _devOtp,
                        style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 10),
                      ),
                    ],
                  ),
                ),

              // OTP label
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Enter 6-Digit OTP',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
              const SizedBox(height: 12),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => _otpBox(i, color)),
              ),
              const SizedBox(height: 20),

              // Timer / resend
              _seconds > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: AppColors.textSub, size: 16),
                        const SizedBox(width: 6),
                        Text('Resend in $_seconds s',
                            style: const TextStyle(
                                color: AppColors.textSub,
                                fontSize: 13)),
                      ],
                    )
                  : TextButton.icon(
                      onPressed: _resendOtp,
                      icon: Icon(Icons.refresh, color: color, size: 16),
                      label: Text('Resend OTP',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold)),
                    ),
              const SizedBox(height: 20),

              // Verify button
              _loading
                  ? CircularProgressIndicator(color: color)
                  : AppButton(
                      label: 'Verify & Continue ✅',
                      color: color,
                      onTap: _verifyOtp,
                    ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index, Color color) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
            fontSize: 24,
            color: AppColors.white,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.accent2.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: AppColors.gold, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (v.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}