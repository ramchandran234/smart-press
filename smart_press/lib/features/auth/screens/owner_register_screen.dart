// lib/features/auth/screens/owner_register_screen.dart
// PPT Screen 3 — Owner Registration Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/responsive_web_wrapper.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();

  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _isDetectingLocation = false;
  double? _latitude;
  double? _longitude;

  Future<void> _detectLiveLocation() async {
    setState(() => _isDetectingLocation = true);
    final loc = await LocationService.getCurrentLiveLocation();
    if (mounted) {
      setState(() {
        _latitude = loc.latitude;
        _longitude = loc.longitude;
        _addressController.text = loc.addressLine1;
        _areaController.text = loc.area;
        _cityController.text = loc.city;
        _isDetectingLocation = false;
      });
      _showSnack('Shop live location auto-filled!', AppColors.green);
    }
  }

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
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
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

  // Removed _showRecoveryDialog

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final shopName = _shopNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || shopName.isEmpty || mobile.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack('Please fill all required fields', AppColors.red);
      return;
    }
    if (mobile.length < 10) {
      _showSnack('Enter a valid mobile number', AppColors.red);
      return;
    }
    if (!email.contains('@')) {
      _showSnack('Enter a valid email address', AppColors.red);
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
        'email': email,
        'shopName': shopName,
        'addressLine1': _addressController.text.trim(),
        'area': _areaController.text.trim(),
        'city': _cityController.text.trim(),
        'latitude': _latitude ?? 12.9716,
        'longitude': _longitude ?? 77.5946,
        'isOpen': true,
      },
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result['success'] == true) {
      await AuthService.logout();
      if (!mounted) return;
      _showSnack('Registration successful!', AppColors.green);
      context.go('/otp?role=owner');
    } else {
      _showSnack(result['error'] ?? 'Registration failed', AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Registration')),
      body: ResponsiveWebWrapper(
        child: SingleChildScrollView(
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
                label: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
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

              // Shop Location section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shop Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  TextButton.icon(
                    onPressed: _isDetectingLocation ? null : _detectLiveLocation,
                    icon: _isDetectingLocation
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                        : const Icon(Icons.my_location, size: 16, color: AppColors.accent),
                    label: Text(
                      _isDetectingLocation ? 'Fetching...' : 'Detect Live Location',
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppTextField(
                label: 'Shop Address',
                hint: 'Shop No, Street Name',
                controller: _addressController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Area / Locality',
                hint: 'e.g. Vadapalani',
                controller: _areaController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'City',
                hint: 'e.g. Chennai',
                controller: _cityController,
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
                      style: TextStyle(fontSize: 13, color: AppColors.white, fontWeight: FontWeight.w500),
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
      ),
    );
  }
}