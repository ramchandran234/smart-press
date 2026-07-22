// lib/core/services/location_web.dart
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<Map<String, double>?> getBrowserLocation() async {
  try {
    final pos = await html.window.navigator.geolocation.getCurrentPosition(
      enableHighAccuracy: true,
      timeout: const Duration(seconds: 10),
    );
    final lat = pos.coords?.latitude?.toDouble();
    final lng = pos.coords?.longitude?.toDouble();
    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
  } catch (e) {
    // Permission denied or timeout
  }
  return null;
}
