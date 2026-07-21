// lib/core/services/auth_service.dart
import 'http_helper.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String mobile,
    required String password,
    required String role,
    Map<String, dynamic>? extra,
  }) async {
    final Map<String, dynamic> payload = {
      'name': name,
      'mobile': mobile,
      'password': password,
      'role': role,
    };
    if (extra != null) {
      payload.addAll(extra);
    }

    final result = await HttpHelper.post(
      '/auth/register',
      payload,
    );

    if (result['success'] == true) {
      await HttpHelper.saveToken(result['token']);
      await HttpHelper.saveUser(result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  static Future<Map<String, dynamic>> login({
    required String mobile,
    required String password,
    required String role,
  }) async {
    final result = await HttpHelper.post(
      '/auth/login',
      {'mobile': mobile, 'password': password, 'role': role},
    );

    if (result['success'] == true) {
      await HttpHelper.saveToken(result['token']);
      await HttpHelper.saveUser(result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  static Future<Map<String, dynamic>> sendOtp({
    required String mobile,
    required String role,
  }) async {
    return HttpHelper.post(
      '/auth/send-otp',
      {'mobile': mobile, 'role': role},
    );
  }

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
      await HttpHelper.saveToken(result['token']);
      await HttpHelper.saveUser(result['user'] as Map<String, dynamic>);
    }

    return result;
  }

  static Future<Map<String, dynamic>> sendPasswordResetOtp({
    required String mobile,
    required String role,
  }) async {
    return HttpHelper.post(
      '/auth/send-reset-otp',
      {'mobile': mobile, 'role': role},
    );
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String mobile,
    required String otp,
    required String password,
  }) async {
    return HttpHelper.post(
      '/auth/reset-password',
      {'mobile': mobile, 'otp': otp, 'password': password},
    );
  }

  static Future<Map<String, dynamic>> resetPasswordWithPin({
    required String mobile,
    required String recoveryPin,
    required String newPassword,
  }) async {
    return HttpHelper.post(
      '/auth/reset-password-pin',
      {
        'mobile': mobile,
        'recoveryPin': recoveryPin,
        'newPassword': newPassword,
      },
    );
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