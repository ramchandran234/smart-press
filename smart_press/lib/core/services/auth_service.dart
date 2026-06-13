// lib/core/services/auth_service.dart
import 'http_helper.dart';

class AuthService {
  // ── Send OTP ──────────────────────────────────────
  static Future<Map<String, dynamic>> sendOtp({
    required String mobile,
    required String role,
  }) async {
    return HttpHelper.post(
      '/auth/send-otp',
      {'mobile': mobile, 'role': role},
    );
  }

  // ── Verify OTP ────────────────────────────────────
  static Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
    required String role,
  }) async {
    final result = await HttpHelper.post(
      '/auth/verify-otp',
      {'mobile': mobile, 'otp': otp, 'role': role},
    );

    if (result['success'] == true) {
      // Save token and user
      await HttpHelper.saveToken(result['token']);
      await HttpHelper.saveUser(
          result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  // ── Get Profile ───────────────────────────────────
  static Future<Map<String, dynamic>>
      getProfile() async {
    return HttpHelper.get('/auth/profile');
  }

  // ── Update Profile ────────────────────────────────
  static Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> data) async {
    return HttpHelper.put('/auth/profile', data);
  }

  // ── Check logged in ───────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await HttpHelper.getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Logout ────────────────────────────────────────
  static Future<void> logout() async {
    await HttpHelper.clearAll();
  }

  // ── Get user role ─────────────────────────────────
  static Future<String> getUserRole() async {
    return HttpHelper.getUserRole();
  }
}