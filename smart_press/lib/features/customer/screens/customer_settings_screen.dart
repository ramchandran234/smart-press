// lib/features/customer/screens/customer_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/http_helper.dart';

class CustomerSettingsScreen extends StatefulWidget {
  const CustomerSettingsScreen({super.key});

  @override
  State<CustomerSettingsScreen> createState() =>
      _CustomerSettingsScreenState();
}

class _CustomerSettingsScreenState
    extends State<CustomerSettingsScreen> {
  bool _notifications = true;
  bool _orderUpdates = true;

  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final u = await HttpHelper.getUser();
      if (mounted) {
        setState(() {
          _user = u;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showEditProfileModal() async {
    final nameCtrl = TextEditingController(text: _user?['name'] as String? ?? '');
    final mobileCtrl = TextEditingController(text: _user?['mobile'] as String? ?? '');
    final addressCtrl = TextEditingController(text: _user?['address'] as String? ?? _user?['addressLine1'] as String? ?? '');
    final cityCtrl = TextEditingController(text: _user?['city'] as String? ?? '');

    bool isSaving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_note, color: AppColors.accent, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.darkBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: mobileCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.darkBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressCtrl,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      labelText: 'Street Address',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.home_outlined, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.darkBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cityCtrl,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      labelText: 'City',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.accent),
                      filled: true,
                      fillColor: AppColors.darkBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isSaving
                          ? null
                          : () async {
                              setModalState(() => isSaving = true);
                              final payload = {
                                'name': nameCtrl.text.trim(),
                                'mobile': mobileCtrl.text.trim(),
                                'address': addressCtrl.text.trim(),
                                'city': cityCtrl.text.trim(),
                              };
                              final res = await AuthService.updateProfile(payload);
                              if (res['success'] == true) {
                                final updatedUser = Map<String, dynamic>.from(_user ?? {})..addAll(payload);
                                await HttpHelper.saveUser(updatedUser);
                                if (!context.mounted) return;
                                Navigator.pop(ctx);
                                if (mounted) {
                                  setState(() => _user = updatedUser);
                                  _showSnack('Profile updated successfully!', AppColors.green);
                                }
                              } else {
                                setModalState(() => isSaving = false);
                                _showSnack(res['error'] ?? 'Failed to update profile', AppColors.red);
                              }
                            },
                      child: isSaving
                          ? const CircularProgressIndicator(color: AppColors.darkBg)
                          : const Text('Save Profile Changes', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBg, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    nameCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?['name'] as String? ?? 'Customer';
    final mobile = _user?['mobile'] as String? ?? '';
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'C';

    final addressLine = _user?['address'] as String? ?? _user?['addressLine1'] as String? ?? 'Not provided';
    final city = _user?['city'] as String? ?? '';
    final fullAddress = city.isNotEmpty ? '$addressLine, $city' : addressLine;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('My Profile & Settings', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: AppColors.darkBg,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.accent.withOpacity(0.2),
                              child: Text(initial,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text('+91 $mobile',
                                  style: const TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showEditProfileModal,
                          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.gold),
                          label: const Text('Edit',
                              style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  _sectionHeader('SAVED ADDRESSES'),
                  _settingTile(
                    icon: Icons.home_outlined,
                    color: AppColors.accent,
                    title: 'Home Address',
                    subtitle: fullAddress,
                    onTap: _showEditProfileModal,
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, color: AppColors.green),
                    ),
                    title: const Text('Add / Update Address',
                        style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600)),
                    onTap: _showEditProfileModal,
                  ),

                  _sectionHeader('NOTIFICATIONS'),
                  SwitchListTile(
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.accent),
                    ),
                    title: const Text('Push Notifications',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
                    subtitle: const Text('Order alerts & offers', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                    value: _notifications,
                    activeColor: AppColors.accent,
                    onChanged: (v) => setState(() => _notifications = v),
                  ),
                  SwitchListTile(
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.sms_outlined, color: AppColors.green),
                    ),
                    title: const Text('SMS Updates',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
                    subtitle: const Text('Status change alerts', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                    value: _orderUpdates,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(() => _orderUpdates = v),
                  ),

                  _sectionHeader('ACCOUNT'),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent2.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history, color: AppColors.accent2),
                    ),
                    title: const Text('Payment History',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
                    subtitle: const Text('View all past transactions', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
                    onTap: () => context.push('/customer/payment-history'),
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textSub.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.help_outline, color: AppColors.textSub),
                    ),
                    title: const Text('Help & Support',
                        style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
                    subtitle: const Text('FAQs and contact us', style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HttpHelper.clearAll();
                          context.go('/');
                        },
                        icon: const Icon(Icons.logout, color: AppColors.red),
                        label: const Text('Logout',
                            style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: _bottomNav(context, 3),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppColors.accent,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.white)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
    );
  }

  Widget _bottomNav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      backgroundColor: AppColors.darkBg,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'Vendors'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (i) {
        const routes = [
          '/customer/dashboard',
          '/customer/orders',
          '/customer/vendors',
          '/customer/settings',
        ];
        context.go(routes[i]);
      },
    );
  }
}