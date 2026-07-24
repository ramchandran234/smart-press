// lib/features/settings/screens/app_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/http_helper.dart';
import '../../../core/services/location_service.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() =>
      _AppSettingsScreenState();
}

class _AppSettingsScreenState
    extends State<AppSettingsScreen> {
  String _language = 'English';
  bool _notifications = true;
  bool _smsAlerts = true;
  bool _autoBackup = false;
  bool _isOpen = true;
  final _languages = [
    'English', 'Hindi', 'Tamil', 'Telugu', 'Kannada'
  ];

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
          if (u != null && u['isOpen'] != null) {
            _isOpen = u['isOpen'] as bool;
          }
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

  Future<void> _showEditShopProfileModal() async {
    final shopNameCtrl = TextEditingController(text: _user?['shopName'] as String? ?? _user?['name'] as String? ?? '');
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
                      Icon(Icons.storefront, color: AppColors.accent, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Edit Shop Profile',
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
                    controller: shopNameCtrl,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      labelText: 'Shop / Owner Name',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.store, color: AppColors.accent),
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
                      labelText: 'Shop Address',
                      labelStyle: const TextStyle(color: AppColors.textSub),
                      prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.accent),
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
                                'shopName': shopNameCtrl.text.trim(),
                                'name': shopNameCtrl.text.trim(),
                                'address': addressCtrl.text.trim(),
                                'city': cityCtrl.text.trim(),
                              };
                              final fullAddr = '${addressCtrl.text.trim()}, ${cityCtrl.text.trim()}';
                              final coords = await LocationService.geocodeAddress(fullAddr);
                              if (coords != null) {
                                payload['latitude'] = coords['lat'];
                                payload['longitude'] = coords['lon'];
                              }
                              final res = await AuthService.updateProfile(payload);
                              setModalState(() => isSaving = false);
                              if (res['success'] == true) {
                                final updatedUser = Map<String, dynamic>.from(_user ?? {})..addAll(payload);
                                await HttpHelper.saveUser(updatedUser);
                                Navigator.pop(ctx);
                                if (mounted) {
                                  setState(() => _user = updatedUser);
                                  _showSnack('Shop profile updated successfully!', AppColors.green);
                                }
                              } else {
                                _showSnack(res['error'] ?? 'Failed to update profile', AppColors.red);
                              }
                            },
                      child: isSaving
                          ? const CircularProgressIndicator(color: AppColors.darkBg)
                          : const Text('Save Shop Profile', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBg, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    shopNameCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopName = _user?['shopName'] as String? ?? _user?['name'] as String? ?? 'Iron Buddy Express';
    final mobile = _user?['mobile'] as String? ?? '';
    final address = _user?['address'] as String? ?? _user?['addressLine1'] as String? ?? 'Shop Location';
    final city = _user?['city'] as String? ?? '';
    final fullAddress = city.isNotEmpty ? '$address, $city' : address;

    final initial = shopName.isNotEmpty ? shopName.substring(0, 1).toUpperCase() : 'I';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('App Settings', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
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
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.accent,
                                    width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent),
                                ),
                              ),
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
                                child: const Icon(Icons.camera_alt,
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
                              Text(shopName,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text('+91 $mobile',
                                  style: const TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 13)),
                              Text(fullAddress,
                                  style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showEditShopProfileModal,
                          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.gold),
                          label: const Text('Edit',
                              style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  _sectionHeader('GENERAL SETTINGS'),
                  _switchItem(
                    icon: Icons.storefront,
                    color: _isOpen ? AppColors.green : AppColors.red,
                    title: 'Shop Status (Open/Closed)',
                    subtitle: _isOpen ? 'Currently OPEN for customer orders' : 'Currently CLOSED for customer orders',
                    value: _isOpen,
                    onChanged: (v) async {
                      setState(() => _isOpen = v);
                      await AuthService.updateProfile({'isOpen': v});
                    },
                  ),
                  _settingItem(
                    icon: Icons.language,
                    color: AppColors.accent2,
                    title: 'Language',
                    subtitle: _language,
                    trailing: DropdownButton<String>(
                      value: _language,
                      dropdownColor: AppColors.darkSurface,
                      underline: const SizedBox(),
                      items: _languages
                          .map((l) => DropdownMenuItem(
                              value: l, child: Text(l, style: const TextStyle(color: AppColors.white))))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _language = v!),
                    ),
                  ),
                  _settingItem(
                    icon: Icons.store_outlined,
                    color: AppColors.orange,
                    title: 'Shop Profile',
                    subtitle: 'Name, address, contact',
                    trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
                    onTap: _showEditShopProfileModal,
                  ),
                  _settingItem(
                    icon: Icons.qr_code,
                    color: AppColors.gold,
                    title: 'Payment QR Code',
                    subtitle: 'Update GPay / PhonePe QR',
                    trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
                    onTap: () => context.push('/settings/qr'),
                  ),

                  _sectionHeader('NOTIFICATIONS'),
                  _switchItem(
                    icon: Icons.notifications_outlined,
                    color: AppColors.accent,
                    title: 'Push Notifications',
                    subtitle: 'Order updates & reminders',
                    value: _notifications,
                    onChanged: (v) =>
                        setState(() => _notifications = v),
                  ),
                  _switchItem(
                    icon: Icons.sms_outlined,
                    color: AppColors.green,
                    title: 'SMS Alerts',
                    subtitle: 'Send SMS to customers',
                    value: _smsAlerts,
                    onChanged: (v) =>
                        setState(() => _smsAlerts = v),
                  ),

                  _sectionHeader('DATA & BACKUP'),
                  _switchItem(
                    icon: Icons.backup_outlined,
                    color: AppColors.accent2,
                    title: 'Auto Backup',
                    subtitle: 'Daily backup to cloud',
                    value: _autoBackup,
                    onChanged: (v) =>
                        setState(() => _autoBackup = v),
                  ),
                  _settingItem(
                    icon: Icons.download_outlined,
                    color: AppColors.green,
                    title: 'Export All Data',
                    subtitle: 'Download full backup',
                    trailing: const Icon(Icons.chevron_right, color: AppColors.cardBorder),
                    onTap: () => context.push('/reports/export'),
                  ),

                  _sectionHeader('ABOUT'),
                  _settingItem(
                    icon: Icons.info_outline,
                    color: AppColors.textSub,
                    title: 'App Version',
                    subtitle: 'v2.0.0 • Iron Buddy',
                    trailing: null,
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        key: const Key('settings_logout_btn'),
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

  Widget _settingItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? trailing,
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
      trailing: trailing,
    );
  }

  Widget _switchItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
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
      trailing: Switch(
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }
}