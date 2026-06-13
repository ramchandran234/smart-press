// lib/core/services/firebase_auth_service.dart
class FirebaseAuthService {
  // All auth is handled by backend API
  // These are stub methods to prevent errors

  static Future<void> sendOtp({
    required String mobile,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    onError(
      'Firebase auth disabled. '
      'Use backend OTP instead.',
    );
  }

  static Future<bool> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    return false;
  }

  static Future<void> signOut() async {}
}