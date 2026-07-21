// lib/features/customer/screens/customer_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
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
      setState(() {
        _user = u;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
        title: const Text('My Profile & Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              child: Column(
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
                              backgroundColor:
                                  AppColors.accent.withOpacity(0.2),
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold)),
                              Text('+91 $mobile',
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Edit',
                                style: TextStyle(
                                    color: AppColors.gold))),
                      ],
                    ),
                  ),

                  _sectionHeader('Saved Addresses'),
                  _settingTile(
                    icon: Icons.home_outlined,
                    color: AppColors.accent,
                    title: 'Home Address',
                    subtitle: fullAddress,
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add,
                          color: AppColors.green),
                    ),
                    title: const Text('Add New Address',
                        style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600)),
                    onTap: () {},
                  ),

                  _sectionHeader('Notifications'),
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
                        style:
                            TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        const Text('Order alerts & offers'),
                    value: _notifications,
                    activeColor: AppColors.accent,
                    onChanged: (v) =>
                        setState(() => _notifications = v),
                  ),
                  SwitchListTile(
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.sms_outlined,
                          color: AppColors.green),
                    ),
                    title: const Text('SMS Updates',
                        style:
                            TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        const Text('Status change alerts'),
                    value: _orderUpdates,
                    activeColor: AppColors.green,
                    onChanged: (v) =>
                        setState(() => _orderUpdates = v),
                  ),

                  _sectionHeader('Account'),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent2.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history,
                          color: AppColors.accent2),
                    ),
                    title: const Text('Payment History',
                        style:
                            TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'View all past transactions'),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.cardBorder),
                    onTap: () => context
                        .push('/customer/payment-history'),
                  ),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textSub.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.help_outline,
                          color: AppColors.textSub),
                    ),
                    title: const Text('Help & Support',
                        style:
                            TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        const Text('FAQs and contact us'),
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
                        onPressed: () {
                          HttpHelper.clearAll();
                          context.go('/');
                        },
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
      bottomNavigationBar: _bottomNav(context, 3),
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

  Widget _settingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
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
          style:
              const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSub)),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.cardBorder),
      onTap: () {},
    );
  }

  Widget _bottomNav(BuildContext context, int index) {
    return BottomNavigationBar(
      currentIndex: index,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSub,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'Vendors'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Profile'),
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