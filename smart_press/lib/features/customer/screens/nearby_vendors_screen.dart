// lib/features/customer/screens/nearby_vendors_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/http_helper.dart';
import '../../../core/services/location_service.dart';
import '../../../shared/widgets/responsive_web_wrapper.dart';

class NearbyVendorsScreen extends StatefulWidget {
  const NearbyVendorsScreen({super.key});

  @override
  State<NearbyVendorsScreen> createState() =>
      _NearbyVendorsScreenState();
}

class _NearbyVendorsScreenState
    extends State<NearbyVendorsScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Open Now', 'Top Rated', 'Nearest'];
  String _search = '';

  List<dynamic> _vendors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    try {
      final custLoc = await LocationService.getCurrentLiveLocation();
      final res = await HttpHelper.get('/auth/vendors');
      if (res['success'] == true) {
        final rawVendors = res['vendors'] as List<dynamic>;
        final mapped = <Map<String, dynamic>>[];
        for (int i = 0; i < rawVendors.length; i++) {
          final rv = rawVendors[i] as Map<String, dynamic>;
          final name = rv['shopName'] as String? ?? rv['name'] as String? ?? 'Laundry Shop';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : 'L';
          final open = rv['isOpen'] != false;

          double vLat = rv['latitude'] != null ? (rv['latitude'] as num).toDouble() : (12.9352 + (i * 0.08));
          double vLng = rv['longitude'] != null ? (rv['longitude'] as num).toDouble() : (77.6245 + (i * 0.08));

          double distanceValue = LocationService.calculateDistance(custLoc.latitude, custLoc.longitude, vLat, vLng);
          bool isOutOfDistance = distanceValue > 10.0;

          final color = [
            AppColors.accent,
            AppColors.green,
            AppColors.orange,
            AppColors.accent2,
            AppColors.gold
          ][i % 5];
          
          mapped.add({
            '_id': rv['_id'],
            'name': name,
            'area': rv['area'] as String? ?? rv['address'] as String? ?? 'Koramangala',
            'distance': '$distanceValue km',
            'distanceValue': distanceValue,
            'isOutOfDistance': isOutOfDistance,
            'rating': 4.5 + (i % 5) * 0.1,
            'reviews': 50 + (i * 12),
            'open': open,
            'services': ['Wash', 'Iron', 'Dry Clean'],
            'minOrder': '₹100',
            'time': '24 hrs',
            'initial': initial,
            'color': color,
          });
        }
        if (mounted) {
          setState(() {
            _vendors = mapped;
            _loading = false;
          });
        }
      } else {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _vendors.where((v) {
      final matchSearch = _search.isEmpty ||
          (v['name'] as String)
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          (v['area'] as String)
              .toLowerCase()
              .contains(_search.toLowerCase());
      final matchFilter = _filter == 'All' ||
          (_filter == 'Open Now' && v['open'] == true) ||
          (_filter == 'Top Rated' &&
              (v['rating'] as double) >= 4.5) ||
          (_filter == 'Nearest');
      return matchSearch && matchFilter;
    }).cast<Map<String, dynamic>>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        automaticallyImplyLeading: false,
        title: const Text('Nearby Vendors'),
        actions: [
          IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(
                12, 12, 12, 8),
            child: TextField(
              onChanged: (v) =>
                  setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search vendors near you...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.accent2),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_search.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear,
                            size: 18),
                        onPressed: () =>
                            setState(() => _search = ''),
                      ),
                    IconButton(
                      icon: const Icon(
                          Icons.my_location,
                          color: AppColors.accent,
                          size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter chips
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(
                12, 0, 12, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final sel = _filter == f;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: 180),
                      margin:
                          const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.accent
                            : AppColors.bgLight,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? AppColors.accent
                                : AppColors.cardBorder),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? AppColors.white
                                  : AppColors.textSub)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Summary
          Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.accent, size: 16),
                const SizedBox(width: 6),
                Text(
                    '${_filtered.length} vendors near Koramangala',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.accent2,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                    '${_vendors.where((v) => v['open'] == true).length} Open Now',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Vendors list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store_outlined,
                            size: 64,
                            color: AppColors.cardBorder),
                        SizedBox(height: 12),
                        Text('No vendors found',
                            style: TextStyle(
                                color: AppColors.textSub,
                                fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) =>
                        _vendorCard(_filtered[i]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(context, 2),
    );
  }

  Widget _vendorCard(Map<String, dynamic> v) {
    final open = v['open'] as bool;
    final color = v['color'] as Color;
    final rating = v['rating'] as double;
    final isOutOfDistance = v['isOutOfDistance'] as bool? ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!open) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shop is currently closed'),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          if (isOutOfDistance) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('out of distance try another shop'),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          context.push('/customer/vendor-order?vendorId=${v['_id']}');
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                          color: color.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        v['initial'] as String,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  v['name'] as String,
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3),
                              decoration: BoxDecoration(
                                color: open
                                    ? AppColors.green
                                        .withOpacity(0.12)
                                    : AppColors.red
                                        .withOpacity(0.12),
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: Text(
                                open ? 'Open' : 'Closed',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: open
                                        ? AppColors.green
                                        : AppColors.red),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 12,
                                color: isOutOfDistance ? AppColors.red : AppColors.textSub),
                            const SizedBox(width: 3),
                            Text(
                                '${v['area']}  •  ${v['distance']}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isOutOfDistance ? FontWeight.bold : FontWeight.normal,
                                    color: isOutOfDistance ? AppColors.red : AppColors.textSub)),
                            if (isOutOfDistance) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '> 10 km',
                                  style: TextStyle(fontSize: 10, color: AppColors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Rating + time + min order
              Row(
                children: [
                  // Stars
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < rating.floor()
                              ? Icons.star
                              : (i < rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                          color: AppColors.gold,
                          size: 14,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                          '$rating (${v['reviews']})',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.access_time,
                      size: 12, color: AppColors.textSub),
                  const SizedBox(width: 3),
                  Text(v['time'] as String,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSub)),
                  const SizedBox(width: 10),
                  Icon(Icons.shopping_bag_outlined,
                      size: 12, color: AppColors.textSub),
                  const SizedBox(width: 3),
                  Text('Min ${v['minOrder']}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSub)),
                ],
              ),
              const SizedBox(height: 10),

              // Services chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (v['services'] as List)
                    .map((s) => Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    color.withOpacity(0.25)),
                          ),
                          child: Text(s,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: color,
                                  fontWeight:
                                      FontWeight.w600)),
                        ))
                    .toList(),
              ),

              if (open && !isOutOfDistance) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call,
                            size: 16),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accent2,
                          side: const BorderSide(
                              color: AppColors.accent2),
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push(
                            '/customer/vendor-order?vendorId=${v['_id']}'),
                        icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 16),
                        label: const Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (isOutOfDistance) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.red.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'out of distance try another shop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.red),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Currently Closed — Opens at 9:00 AM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSub),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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
            icon: Icon(Icons.store), label: 'Vendors'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile'),
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