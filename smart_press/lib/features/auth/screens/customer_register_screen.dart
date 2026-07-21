// lib/features/auth/screens/customer_register_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

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
  final _passwordController = TextEditingController();
  final _whatsappController= TextEditingController();
  final _addressController = TextEditingController();
  final _areaController    = TextEditingController();
  final _cityController    = TextEditingController();

  bool _whatsappSame = true;
  bool _isLoading    = false;
  String _preferredSlot = 'Evening (4PM–8PM)';

  final _slots = [
    'Morning (9AM–12PM)',
    'Afternoon (12PM–4PM)',
    'Evening (4PM–8PM)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
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
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.green.withOpacity(0.3)),
                  ),
                  child: SelectableText(
                    recoveryPin,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: AppColors.green,
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
                context.go('/otp?role=customer');
              },
              child: const Text('OK, Copied PIN', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent2)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    final name     = _nameController.text.trim();
    final mobile   = _mobileController.text.trim();
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
        'addressLine1': _addressController.text.trim(),
        'area': _areaController.text.trim(),
        'city': city,
        'whatsapp': _whatsappSame ? mobile : _whatsappController.text.trim(),
        'preferredSlot': _preferredSlot,
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
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Customer Registration'),
      ),
      body: SingleChildScrollView(
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

            // Address
            _sectionLabel('Address'),
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