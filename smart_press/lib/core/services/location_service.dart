// lib/core/services/location_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
  /// Calculate Haversine distance in kilometers between two geographic coordinates
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371; // Earth radius in km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = R * c;
    return double.parse(distance.toStringAsFixed(1));
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  /// Get exact live location coordinates and real address details using Browser HTML5 GPS Geolocation & OpenStreetMap reverse geocoding.
  static Future<LocationDataResult> getCurrentLiveLocation() async {
    try {
      double? lat;
      double? lon;
      String defaultCity = 'Bengaluru';

      // Step 1: Attempt HTML5 Browser Native Geolocation (Prompts Chrome for exact device GPS)
      try {
        final browserCoords = await getBrowserLocation();
        if (browserCoords != null && browserCoords['lat'] != null && browserCoords['lng'] != null) {
          lat = browserCoords['lat'];
          lon = browserCoords['lng'];
        }
      } catch (_) {}

      // Step 2: Fallback to Network IP Geolocation if browser GPS is denied or unavailable
      if (lat == null || lon == null) {
        try {
          final ipRes = await http.get(Uri.parse('http://ip-api.com/json')).timeout(const Duration(seconds: 4));
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

      // Default safe fallbacks if still null
      lat ??= 12.9716;
      lon ??= 77.5946;

      // Step 3: Reverse Geocode via OpenStreetMap Nominatim API for exact address details
      String addressLine1 = '$defaultCity Center';
      String area = defaultCity;
      String city = defaultCity;

      try {
        final revUri = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
        final revRes = await http.get(revUri, headers: {
          'User-Agent': 'SmartPressApp/1.0',
        }).timeout(const Duration(seconds: 5));

        if (revRes.statusCode == 200) {
          final revData = jsonDecode(revRes.body) as Map<String, dynamic>;
          final addr = revData['address'] as Map<String, dynamic>?;

          if (addr != null) {
            final road = addr['road'] as String? ?? addr['pedestrian'] as String? ?? addr['suburb'] as String? ?? addr['residential'] as String?;
            final neighbourhood = addr['neighbourhood'] as String? ?? addr['suburb'] as String? ?? addr['residential'] as String? ?? addr['village'] as String?;
            final cityName = addr['city'] as String? ?? addr['town'] as String? ?? addr['state_district'] as String? ?? defaultCity;

            if (road != null && road.isNotEmpty) {
              addressLine1 = road;
            } else if (neighbourhood != null) {
              addressLine1 = neighbourhood;
            }

            if (neighbourhood != null && neighbourhood.isNotEmpty) {
              area = neighbourhood;
            } else {
              area = cityName;
            }

            city = cityName.replaceAll(' Corporation', '').replaceAll(' District', '');
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
