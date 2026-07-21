// lib/features/customers/screens/add_customer_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/customer_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();

  bool _whatsappSame = true;
  bool _isLoading = false;
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
    _whatsappController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _notesController.dispose();
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

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final whatsapp = _whatsappSame ? mobile : _whatsappController.text.trim();
    final address = _addressController.text.trim();
    final area = _areaController.text.trim();
    final city = _cityController.text.trim();
    final notes = _notesController.text.trim();

    if (name.isEmpty) {
      _showSnack('Please enter customer name', AppColors.red);
      return;
    }
    if (mobile.isEmpty || mobile.length < 10) {
      _showSnack('Please enter a valid 10-digit mobile number', AppColors.red);
      return;
    }

    setState(() => _isLoading = true);

    final data = {
      'name': name,
      'mobile': mobile,
      'whatsapp': whatsapp,
      'addressLine1': address,
      'area': area,
      'city': city,
      'notes': notes,
      'preferredSlot': _preferredSlot,
    };

    try {
      final res = await CustomerService.createCustomer(data);
      setState(() => _isLoading = false);

      if (!mounted) return;

      if (res['success'] == true) {
        _showSnack('Customer added successfully!', AppColors.green);
        context.pop();
      } else {
        _showSnack(res['error'] ?? 'Failed to add customer', AppColors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Error: $e', AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.accent2,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.person_add_alt_1,
                        color: AppColors.white, size: 20),
                    SizedBox(width: 8),
                    Text('New Customer Profile',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white)),
                  ]),
                  SizedBox(height: 4),
                  Text(
                    'Fill in information below to create a customer profile in your laundry database.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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
              hint: 'Enter customer name',
              controller: _nameController,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Mobile Number',
              hint: 'Enter 10-digit mobile number',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // WhatsApp Same Toggle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: AppColors.green, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WhatsApp same as mobile?',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('We send order updates on WhatsApp',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _whatsappSame,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(() => _whatsappSame = v),
                  ),
                ],
              ),
            ),
            if (!_whatsappSame) ...[
              const SizedBox(height: 14),
              AppTextField(
                label: 'WhatsApp Number',
                hint: 'Enter WhatsApp number',
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
              ),
            ],
            const SizedBox(height: 20),

            // Address section
            _sectionLabel('Address Details'),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Address Line 1',
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
            _sectionLabel('Preferences & Notes'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _preferredSlot,
              decoration: const InputDecoration(
                labelText: 'Preferred Delivery Slot',
                prefixIcon: Icon(Icons.access_time, color: AppColors.accent2),
              ),
              items: _slots
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _preferredSlot = v!),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Notes / Remarks',
              hint: 'e.g. Special instructions, landmark',
              controller: _notesController,
              maxLines: 2,
            ),
            const SizedBox(height: 28),

            // Action Button
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent))
                : AppButton(
                    label: 'Save Customer Profile',
                    color: AppColors.accent,
                    onTap: _submit,
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
            color: AppColors.accent,
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
