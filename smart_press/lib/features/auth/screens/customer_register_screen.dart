// lib/features/auth/screens/customer_register_screen.dart
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

class CustomerRegisterScreen extends StatefulWidget {
  const CustomerRegisterScreen({super.key});

  @override
  State<CustomerRegisterScreen> createState() =>
      _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState
    extends State<CustomerRegisterScreen> {
  final _nameController    = TextEditingController();
  final _mobileController  = TextEditingController();
  final _emailController   = TextEditingController();
  final _passwordController = TextEditingController();
  final _whatsappController= TextEditingController();
  final _addressController = TextEditingController();
  final _areaController    = TextEditingController();
  final _cityController    = TextEditingController();

  bool _whatsappSame = true;
  bool _isLoading    = false;
  bool _isDetectingLocation = false;
  double? _latitude;
  double? _longitude;
  String _preferredSlot = 'Evening (4PM–8PM)';

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
      _showSnack('Live location auto-filled!', AppColors.green);
    }
  }

  final _slots = [
    'Morning (9AM–12PM)',
    'Afternoon (12PM–4PM)',
    'Evening (4PM–8PM)',
  ];

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
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _cityController.dispose();
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
    final name     = _nameController.text.trim();
    final mobile   = _mobileController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final city     = _cityController.text.trim();

    if (name.isEmpty) {
      _showSnack('Please enter your name',
          AppColors.red);
      return;
    }
    if (mobile.isEmpty || mobile.length < 10) {
      _showSnack('Enter valid mobile number',
          AppColors.red);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Enter valid email address',
          AppColors.red);
      return;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', AppColors.red);
      return;
    }
    if (city.isEmpty) {
      _showSnack('Please enter your city',
          AppColors.red);
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      name: name,
      mobile: mobile,
      password: password,
      role: 'customer',
      extra: {
        'email': email,
        'addressLine1': _addressController.text.trim(),
        'area': _areaController.text.trim(),
        'city': city,
        'latitude': _latitude ?? 12.9352,
        'longitude': _longitude ?? 77.6245,
        'whatsapp': _whatsappSame ? mobile : _whatsappController.text.trim(),
        'preferredSlot': _preferredSlot,
      },
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      await AuthService.logout();
      if (!mounted) return;
      _showSnack('Registration successful!', AppColors.green);
      context.go('/otp?role=customer');
    } else {
      _showSnack(result['error'] ?? 'Registration failed', AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Customer Registration'),
      ),
      body: ResponsiveWebWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.green,
                    AppColors.accent2,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.person_add,
                        color: AppColors.white,
                        size: 20),
                    SizedBox(width: 8),
                    Text('Create Customer Account',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                            color: AppColors.white)),
                  ]),
                  SizedBox(height: 4),
                  Text(
                    'Register to track your laundry orders',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal details
            _sectionLabel('Personal Details'),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameController,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Mobile Number',
              hint: '+91 XXXXXXXXXX',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Password',
              hint: 'Enter a password',
              controller: _passwordController,
              obscure: true,
            ),
            const SizedBox(height: 14),

            // WhatsApp same toggle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat,
                      color: AppColors.green,
                      size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                            'WhatsApp same as mobile?',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                                fontSize: 14)),
                        Text(
                            'We send order updates on WhatsApp',
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    AppColors.textSub)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _whatsappSame,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(
                        () => _whatsappSame = v),
                  ),
                ],
              ),
            ),
            if (!_whatsappSame) ...[
              const SizedBox(height: 14),
              AppTextField(
                label: 'WhatsApp Number',
                hint: '+91 XXXXXXXXXX',
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
              ),
            ],
            const SizedBox(height: 20),

            // Address & Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel('Address & Location'),
                TextButton.icon(
                  onPressed: _isDetectingLocation ? null : _detectLiveLocation,
                  icon: _isDetectingLocation
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.green))
                      : const Icon(Icons.my_location, size: 16, color: AppColors.green),
                  label: Text(
                    _isDetectingLocation ? 'Fetching...' : 'Detect Live Location',
                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Address',
              hint: 'House/Flat No, Street Name',
              controller: _addressController,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Area / Locality',
              hint: 'e.g. Koramangala',
              controller: _areaController,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'City',
              hint: 'e.g. Bengaluru',
              controller: _cityController,
            ),
            const SizedBox(height: 20),

            // Preferences
            _sectionLabel('Preferences'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _preferredSlot,
              decoration: const InputDecoration(
                labelText: 'Preferred Pickup Slot',
                prefixIcon: Icon(Icons.access_time,
                    color: AppColors.accent2),
              ),
              items: _slots
                  .map((s) => DropdownMenuItem(
                      value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _preferredSlot = v!),
            ),
            const SizedBox(height: 28),

            // Register button
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.green))
                : AppButton(
                    label: 'Register & Continue',
                    color: AppColors.green,
                    onTap: () { _register(); },
                  ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                      color: AppColors.accent2),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textDark)),
      ],
    );
  }
}