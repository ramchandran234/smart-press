// lib/features/settings/screens/app_settings_screen.dart
// PPT Screen 39 — App Settings Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

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
  final _languages = [
    'English', 'Hindi', 'Tamil', 'Telugu', 'Kannada'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: SingleChildScrollView(
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
                          color: AppColors.accent
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.accent,
                              width: 2),
                        ),
                        child: const Icon(Icons.store,
                            size: 36,
                            color: AppColors.accent),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Smart Press',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold)),
                        Text('+91 98765 00000',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13)),
                        Text('Koramangala, Bengaluru',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit',
                        style: TextStyle(
                            color: AppColors.gold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            _sectionHeader('General'),
            _settingItem(
              icon: Icons.language,
              color: AppColors.accent2,
              title: 'Language',
              subtitle: _language,
              trailing: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: _languages
                    .map((l) => DropdownMenuItem(
                        value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _language = v!),
              ),
            ),
            _settingItem(
              icon: Icons.store_outlined,
              color: AppColors.orange,
              title: 'Shop Profile',
              subtitle: 'Name, address, hours',
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.cardBorder),
              onTap: () {},
            ),
            _settingItem(
              icon: Icons.qr_code,
              color: AppColors.gold,
              title: 'Payment QR Code',
              subtitle: 'Update GPay / PhonePe QR',
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.cardBorder),
              onTap: () => context.push('/settings/qr'),
            ),

            _sectionHeader('Notifications'),
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

            _sectionHeader('Data & Backup'),
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
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.cardBorder),
              onTap: () => context.push('/reports/export'),
            ),

            _sectionHeader('About'),
            _settingItem(
              icon: Icons.info_outline,
              color: AppColors.textSub,
              title: 'App Version',
              subtitle: 'v1.0.0',
              trailing: null,
            ),
            _settingItem(
              icon: Icons.support_agent,
              color: AppColors.accent,
              title: 'Support',
              subtitle: 'Contact us for help',
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.cardBorder),
              onTap: () {},
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  key: const Key('settings_logout_btn'),
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.logout,
                      color: AppColors.red),
                  label: const Text('Logout',
                      style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSub,
              letterSpacing: 1)),
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
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSub)),
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
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSub)),
      trailing: Switch(
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }
}