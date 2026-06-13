// lib/core/services/api_service.dart
import 'http_helper.dart';

class ApiService {
  // Wraps HttpHelper for easy use
  static Future<Map<String, dynamic>> get(
      String endpoint) async {
    return HttpHelper.get(endpoint);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    return HttpHelper.post(
      endpoint,
      body,
      withAuth: auth,
    );
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return HttpHelper.put(endpoint, body);
  }

  static Future<Map<String, dynamic>> delete(
      String endpoint) async {
    return HttpHelper.delete(endpoint);
  }

  static Future<String?> getToken() =>
      HttpHelper.getToken();

  static Future<void> saveToken(String t) =>
      HttpHelper.saveToken(t);

  static Future<void> saveUserData(
          Map<String, dynamic> u) =>
      HttpHelper.saveUser(u);

  static Future<Map<String, dynamic>?> getUserData() =>
      HttpHelper.getUser();

  static Future<String> getUserRole() =>
      HttpHelper.getUserRole();

  static Future<void> clearToken() =>
      HttpHelper.clearAll();
}