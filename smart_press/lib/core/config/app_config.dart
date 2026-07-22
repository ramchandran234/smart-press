// lib/core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  // Set to true for local server (Instant 5ms response)
  // Set to false for live Render Cloud server
  static const bool isLocalDev = true;

  static String get baseUrl {
    if (isLocalDev) {
      if (kIsWeb) {
        return "http://127.0.0.1:5000/api";
      }
      return "http://127.0.0.1:5000/api";
    }
    return "https://smart-press-backend.onrender.com/api";
  }
}