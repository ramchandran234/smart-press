// lib/features/customer/screens/create_vendor_order_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/http_helper.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/responsive_web_wrapper.dart';

import '../../../core/services/location_service.dart';

class CreateVendorOrderScreen extends StatefulWidget {
  final String? vendorId;
  const CreateVendorOrderScreen({super.key, this.vendorId});

  @override
  State<CreateVendorOrderScreen> createState() =>
      _CreateVendorOrderScreenState();
}

class _CreateVendorOrderScreenState
    extends State<CreateVendorOrderScreen> {
  String _service = 'Wash + Iron';
  final _services = [
    'Wash + Iron', 'Dry Clean', 'Iron Only', 'Wash Only'
  ];

  final List<Map<String, dynamic>> _garments = [
    {'name': 'Shirt', 'qty': 2, 'price': 40},
    {'name': 'Trouser', 'qty': 1, 'price': 50},
  ];

  final _notesController = TextEditingController();

  Map<String, dynamic>? _selectedVendor;
  bool _loadingVendor = true;
  bool _submitting = false;

  double _calculatedDistance = 0.3;
  bool _isShopOpen = true;
  bool _isOutOfDistance = false;
  LocationDataResult? _customerLocation;

  @override
  void initState() {
    super.initState();
    _loadVendor();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadVendor() async {
    try {
      final custLoc = await LocationService.getCurrentLiveLocation();
      _customerLocation = custLoc;

      final res = await HttpHelper.get('/auth/vendors');
      if (res['success'] == true) {
        final vendorsList = res['vendors'] as List<dynamic>;
        final matched = vendorsList.firstWhere(
          (v) => v['_id'] == widget.vendorId,
          orElse: () => null,
        ) as Map<String, dynamic>?;

        double dist = 0.3;
        bool open = true;
        bool outOfDist = false;

        if (matched != null) {
          open = matched['isOpen'] != false;
          double vLat = matched['latitude'] != null ? (matched['latitude'] as num).toDouble() : 12.9352;
          double vLng = matched['longitude'] != null ? (matched['longitude'] as num).toDouble() : 77.6245;
          dist = LocationService.calculateDistance(custLoc.latitude, custLoc.longitude, vLat, vLng);
          outOfDist = dist > 10.0;
        }

        setState(() {
          _selectedVendor = matched;
          _calculatedDistance = dist;
          _isShopOpen = open;
          _isOutOfDistance = outOfDist;
          _loadingVendor = false;
        });
      } else {
        setState(() => _loadingVendor = false);
      }
    } catch (e) {
      setState(() => _loadingVendor = false);
    }
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

  Future<void> _placeOrder() async {
    if (widget.vendorId == null) {
      _showSnack('Error: No vendor selected', AppColors.red);
      return;
    }
    if (!_isShopOpen) {
      _showSnack('Shop is currently closed', AppColors.red);
      return;
    }
    if (_isOutOfDistance) {
      _showSnack('out of distance try another shop', AppColors.red);
      return;
    }
    if (_garments.isEmpty) {
      _showSnack('Please add at least one garment', AppColors.red);
      return;
    }

    setState(() => _submitting = true);

    final payload = {
      'ownerId': widget.vendorId,
      'garments': _garments.map((g) => {
        'name': g['name'],
        'qty': g['qty'],
        'rate': g['price'] ?? 40,
      }).toList(),
      'orderType': 'pickup',
      'serviceType': _service,
      'notes': _notesController.text.trim(),
      'customerLat': _customerLocation?.latitude,
      'customerLng': _customerLocation?.longitude,
      'distance': _calculatedDistance,
    };

    try {
      final res = await HttpHelper.post('/orders/customer-app', payload, withAuth: true);
      setState(() => _submitting = false);

      if (!mounted) return;

      if (res['success'] == true) {
        _showSnack('Order placed successfully!', AppColors.green);
        context.go('/customer/orders');
      } else {
        _showSnack(res['error'] ?? 'Failed to place order', AppColors.red);
      }
    } catch (e) {
      setState(() => _submitting = false);
      _showSnack('Error: $e', AppColors.red);
    }
  }

  void _addGarmentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Garment',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  'Shirt', 'Trouser', 'Saree', 'Kurta',
                  'Bedsheet', 'Towel', 'Jacket', 'Jeans', 'T-Shirt'
                ].map((g) {
                  // Determine dummy prices
                  int price = 40;
                  if (g == 'Jacket') price = 120;
                  if (g == 'Saree') price = 80;
                  if (g == 'Trouser' || g == 'Jeans') price = 50;

                  return ListTile(
                    leading: const Icon(Icons.checkroom,
                        color: AppColors.accent),
                    title: Text('$g (₹$price)'),
                    onTap: () {
                      setState(() => _garments.add(
                          {'name': g, 'qty': 1, 'price': price}));
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendorName = _selectedVendor != null
        ? _selectedVendor!['shopName'] as String? ?? _selectedVendor!['name'] as String? ?? 'Laundry Shop'
        : 'Laundry Shop';
    final vendorAddress = _selectedVendor != null
        ? _selectedVendor!['address'] as String? ?? 'Koramangala'
        : 'Koramangala';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Create Vendor Order'),
      ),
      body: _loadingVendor
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected vendor info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: (_isOutOfDistance || !_isShopOpen)
                          ? AppColors.red.withOpacity(0.08)
                          : AppColors.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: (_isOutOfDistance || !_isShopOpen)
                              ? AppColors.red.withOpacity(0.4)
                              : AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.store,
                                color: AppColors.accent, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(vendorName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _isShopOpen ? AppColors.green.withOpacity(0.12) : AppColors.red.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _isShopOpen ? 'Open' : 'Closed',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: _isShopOpen ? AppColors.green : AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                      '$vendorAddress  •  ${_calculatedDistance.toStringAsFixed(1)} km away  •  ⭐ 4.8',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: _isOutOfDistance ? FontWeight.bold : FontWeight.normal,
                                          color: _isOutOfDistance ? AppColors.red : AppColors.textSub)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_isOutOfDistance) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '⚠️ out of distance try another shop (${_calculatedDistance.toStringAsFixed(1)} km > 10 km limit)',
                              style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Service type
                  _label('Service Type'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _service,
                    decoration: const InputDecoration(),
                    items: _services
                        .map((s) => DropdownMenuItem(
                            value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _service = v!),
                  ),
                  const SizedBox(height: 20),

                  // Garments
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _label('Garments'),
                      TextButton.icon(
                        onPressed: _addGarmentDialog,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._garments.asMap().entries.map((e) {
                    final i = e.key;
                    final g = e.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(g['name'],
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600))),
                          IconButton(
                            icon: const Icon(
                                Icons.remove_circle_outline,
                                color: AppColors.red,
                                size: 20),
                            onPressed: () => setState(() {
                              if (g['qty'] > 1) g['qty']--;
                            }),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text('${g['qty']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          IconButton(
                            icon: const Icon(
                                Icons.add_circle_outline,
                                color: AppColors.green,
                                size: 20),
                            onPressed: () =>
                                setState(() => g['qty']++),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Text('₹${(g['price'] ?? 40) * g['qty']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.accent2)),
                          IconButton(
                            icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.red,
                                size: 18),
                            onPressed: () => setState(
                                () => _garments.removeAt(i)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Pickup mode
                  _label('Pickup Mode'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping,
                            color: AppColors.green),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Home Pickup',
                                  style: TextStyle(
                                      fontWeight:
                                          BorderWeight.bold)),
                              Text(
                                  'Registered Address',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSub)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => context
                              .push('/customer/delivery-mode'),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Special instructions notes
                  _label('Special Instructions'),
                  const SizedBox(height: 10),
                  AppTextField(
                    label: 'Instructions',
                    hint: 'e.g. Wash separately, no fabric softener...',
                    controller: _notesController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Amount estimate
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimated Total',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14)),
                        Text(
                            '₹${_garments.fold(0, (s, g) => s + (g['qty'] as int) * (g['price'] as int? ?? 40))}',
                            style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _submitting
                      ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                      : !_isShopOpen
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.red.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.red),
                              ),
                              child: const Text(
                                'Shop is Currently Closed',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            )
                          : _isOutOfDistance
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.red.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.red),
                                  ),
                                  child: const Text(
                                    'out of distance try another shop',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                )
                              : AppButton(
                                  label: 'Place Vendor Order (${_calculatedDistance.toStringAsFixed(1)} km)',
                                  color: AppColors.accent,
                                  onTap: _placeOrder,
                                ),
                ],
              ),
            ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textDark));
}
class BorderWeight {
  static const FontWeight bold = FontWeight.bold;
}