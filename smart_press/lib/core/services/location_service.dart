// lib/core/services/location_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'location_stub.dart' if (dart.library.html) 'location_web.dart';

class LocationDataResult {
  final double latitude;
  final double longitude;
  final String addressLine1;
  final String area;
  final String city;

  LocationDataResult({
    required this.latitude,
    required this.longitude,
    required this.addressLine1,
    required this.area,
    required this.city,
  });
}

class LocationService {
  /// Haversine distance in kilometers between two coordinates
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return double.parse((R * c).toStringAsFixed(1));
  }

  static double _toRadians(double degree) => degree * pi / 180;

  /// Get real GPS location — uses device GPS on mobile, browser on web
  static Future<LocationDataResult> getCurrentLiveLocation() async {
    try {
      double? lat;
      double? lon;
      String defaultCity = 'Bengaluru';

      // ── Step 1: Native device GPS (Android / iOS) ─────────────────────
      if (!kIsWeb) {
        try {
          // Check & request permission
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }

          if (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse) {
            final Position pos = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            ).timeout(const Duration(seconds: 12));
            lat = pos.latitude;
            lon = pos.longitude;
          }
        } catch (_) {}
      }

      // ── Step 2: Browser HTML5 GPS (Web only) ──────────────────────────
      if (kIsWeb && (lat == null || lon == null)) {
        try {
          final browserCoords = await getBrowserLocation();
          if (browserCoords != null &&
              browserCoords['lat'] != null &&
              browserCoords['lng'] != null) {
            lat = browserCoords['lat'];
            lon = browserCoords['lng'];
          }
        } catch (_) {}
      }

      // ── Step 3: IP-based fallback (if GPS denied or unavailable) ──────
      if (lat == null || lon == null) {
        try {
          final ipRes = await http
              .get(Uri.parse('http://ip-api.com/json'))
              .timeout(const Duration(seconds: 4));
          if (ipRes.statusCode == 200) {
            final data = jsonDecode(ipRes.body) as Map<String, dynamic>;
            if (data['status'] == 'success') {
              lat = (data['lat'] as num).toDouble();
              lon = (data['lon'] as num).toDouble();
              defaultCity = data['city'] as String? ?? 'Bengaluru';
            }
          }
        } catch (_) {}
      }

      // ── Hard fallback ─────────────────────────────────────────────────
      lat ??= 12.9716;
      lon ??= 77.5946;

      // ── Step 4: Reverse geocode via OpenStreetMap Nominatim ───────────
      String addressLine1 = '$defaultCity Center';
      String area = defaultCity;
      String city = defaultCity;

      try {
        final revUri = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
        final revRes = await http.get(revUri, headers: {
          'User-Agent': 'SmartPressApp/1.0',
        }).timeout(const Duration(seconds: 6));

        if (revRes.statusCode == 200) {
          final revData = jsonDecode(revRes.body) as Map<String, dynamic>;
          final addr = revData['address'] as Map<String, dynamic>?;

          if (addr != null) {
            final road = addr['road'] as String? ??
                addr['pedestrian'] as String? ??
                addr['suburb'] as String? ??
                addr['residential'] as String?;
            final neighbourhood = addr['neighbourhood'] as String? ??
                addr['suburb'] as String? ??
                addr['residential'] as String? ??
                addr['village'] as String?;
            final cityName = addr['city'] as String? ??
                addr['town'] as String? ??
                addr['state_district'] as String? ??
                defaultCity;

            addressLine1 =
                (road != null && road.isNotEmpty) ? road : neighbourhood ?? cityName;
            area = (neighbourhood != null && neighbourhood.isNotEmpty)
                ? neighbourhood
                : cityName;
            city = cityName
                .replaceAll(' Corporation', '')
                .replaceAll(' District', '');
          }
        }
      } catch (_) {}

      return LocationDataResult(
        latitude: lat,
        longitude: lon,
        addressLine1: addressLine1,
        area: area,
        city: city,
      );
    } catch (e) {
      return LocationDataResult(
        latitude: 12.9716,
        longitude: 77.5946,
        addressLine1: 'Main Street',
        area: 'Koramangala',
        city: 'Bengaluru',
      );
    }
  }
}
