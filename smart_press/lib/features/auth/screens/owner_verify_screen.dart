// lib/features/auth/screens/owner_verify_screen.dart
// PPT Screen 4 — Owner Verification Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class OwnerVerifyScreen extends StatefulWidget {
  const OwnerVerifyScreen({super.key});

  @override
  State<OwnerVerifyScreen> createState() =>
      _OwnerVerifyScreenState();
}

class _OwnerVerifyScreenState extends State<OwnerVerifyScreen> {
  String? _selectedCategory;
  final List<String> _categories = [
    'Laundry',
    'Dry Cleaning',
    'Ironing',
    'All Services'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Verification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.gold),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Complete verification to activate your account',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Upload Documents',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 14),
            _uploadTile(
              icon: Icons.store_mall_directory_outlined,
              label: 'Shop Image',
              hint: 'Upload a clear photo of your shop front',
              color: AppColors.accent,
            ),
            const SizedBox(height: 12),
            _uploadTile(
              icon: Icons.location_on_outlined,
              label: 'Shop Location',
              hint: 'Tap to pick your GPS location',
              color: AppColors.green,
            ),
            const SizedBox(height: 12),
            _uploadTile(
              icon: Icons.credit_card,
              label: 'Aadhaar Card — Front',
              hint: 'Upload front side of Aadhaar card',
              color: AppColors.orange,
            ),
            const SizedBox(height: 12),
            _uploadTile(
              icon: Icons.credit_card_outlined,
              label: 'Aadhaar Card — Back',
              hint: 'Upload back side of Aadhaar card',
              color: AppColors.orange,
            ),
            const SizedBox(height: 20),
            const Text('Business Details',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Business Category',
              ),
              items: _categories
                  .map((s) => DropdownMenuItem(
                      value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'GST Number (Optional)',
                hintText: '22AAAAA0000A1Z5',
              ),
            ),
            const SizedBox(height: 28),
            AppButton(
  label: 'Submit for Verification ✓',
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            '✅ Registration submitted! Please login to continue.'),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go('/');
      }
    });
  },
),
          ],
        ),
      ),
    );
  }

  Widget _uploadTile({
    required IconData icon,
    required String label,
    required String hint,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text(hint,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSub)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.upload_rounded,
                color: color, size: 18),
          ),
        ],
      ),
    );
  }
}