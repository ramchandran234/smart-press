// lib/core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  // Set to true to test local Node server on PC/Mobile device
  // Set to false to test live Render Cloud server
  static const bool isLocalDev = true;

  // Your PC's Wi-Fi IPv4 address for direct phone testing
  static const String localNetworkIp = "192.168.1.6";

  static String get baseUrl {
    if (isLocalDev) {
      if (kIsWeb) {
        return "http://127.0.0.1:5000/api";
      }
      // For physical Android / iOS mobile devices
      // ADB Port Reverse or Local Wi-Fi IP fallback
      return "http://127.0.0.1:5000/api";
    }
    return "https://smart-press-backend.onrender.com/api";
  }
}