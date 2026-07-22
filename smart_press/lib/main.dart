// lib/main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/config/app_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Start warming up Render backend in the background immediately
  http.get(Uri.parse(AppConfig.baseUrl.replaceAll('/api', ''))).then((_) {}).catchError((_) {});
  runApp(const SmartPressApp());
}