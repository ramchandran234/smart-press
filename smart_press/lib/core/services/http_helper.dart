// lib/core/services/http_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class HttpHelper {
  static const String baseUrl = AppConfig.baseUrl;

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
    await prefs.setString('user_role', user['role'] ?? 'customer');
    await prefs.setString('user_name', user['name'] ?? 'User');
    await prefs.setString('user_mobile', user['mobile'] ?? '');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role') ?? 'customer';
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool withAuth = false,
  }) async {
    try {
      print('🌐 POST → $baseUrl$endpoint');
      print('📦 Body → $body');
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _headers(withAuth: withAuth),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      print('✅ Status → ${response.statusCode}');
      print('📩 Response → ${response.body}');
      return _parse(response);
    } catch (e) {
      // ✅ Now prints REAL error
      print('❌ POST ERROR → $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      print('🌐 GET → $baseUrl$endpoint');
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _headers(withAuth: true),
          )
          .timeout(const Duration(seconds: 30));
      print('✅ Status → ${response.statusCode}');
      print('📩 Response → ${response.body}');
      return _parse(response);
    } catch (e) {
      print('❌ GET ERROR → $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      print('🌐 PUT → $baseUrl$endpoint');
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _headers(withAuth: true),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      print('✅ Status → ${response.statusCode}');
      print('📩 Response → ${response.body}');
      return _parse(response);
    } catch (e) {
      print('❌ PUT ERROR → $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      print('🌐 DELETE → $baseUrl$endpoint');
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _headers(withAuth: true),
          )
          .timeout(const Duration(seconds: 30));
      print('✅ Status → ${response.statusCode}');
      print('📩 Response → ${response.body}');
      return _parse(response);
    } catch (e) {
      print('❌ DELETE ERROR → $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Map<String, dynamic> _parse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'error': 'Invalid server response: ${response.body}'};
    }
  }
}