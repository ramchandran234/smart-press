// lib/core/services/firebase_service.dart
class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    _initialized = true;
    // Firebase disabled
    // OTP is handled by Node.js backend + MongoDB
  }

  static bool get isInitialized => _initialized;
}