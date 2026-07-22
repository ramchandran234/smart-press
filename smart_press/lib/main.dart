// lib/main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/config/app_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Warm up Render cloud backend immediately in background on app startup
  http.get(Uri.parse('https://smart-press-backend.onrender.com/')).then((_) {}).catchError((_) {});
  http.get(Uri.parse(AppConfig.baseUrl.replaceAll('/api', ''))).then((_) {}).catchError((_) {});
  runApp(const SmartPressApp());
}