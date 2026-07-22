// lib/app.dart
import 'package:flutter/material.dart';
import 'package:smart_press/core/routes/app_routes.dart';
import 'package:smart_press/core/theme/app_theme.dart';

class SmartPressApp extends StatelessWidget {
  const SmartPressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Iron Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}