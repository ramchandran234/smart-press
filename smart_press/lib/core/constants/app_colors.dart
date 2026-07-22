// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary     = darkBg;

  // Ultra-modern glassmorphic palette
  static const Color darkBg      = Color(0xFF0F1535); // Midnight Navy Deep
  static const Color darkSurface = Color(0xFF18204A); // Glass Card Surface
  static const Color accent      = Color(0xFF00F2FE); // Neon Cyan / Electric Blue
  static const Color accent2     = Color(0xFF4FACFE); // Vibrant Electric Sky
  static const Color gold        = Color(0xFFFFD700); // Glowing Vivid Gold
  static const Color white       = Color(0xFFFFFFFF);
  static const Color bgLight     = Color(0xFF0B0F2A); // Modern Dark Canvas
  static const Color cardBorder  = Color(0x3300F2FE); // Translucent Neon Border
  static const Color highlight   = Color(0x1F00F2FE); // Subtle Accent Highlight
  static const Color textDark    = Color(0xFFF0F4FF); // Bright White Text
  static const Color textSub     = Color(0xFF8E9BCC); // Muted Lavender Slate
  static const Color green       = Color(0xFF00E676); // Neon Emerald
  static const Color red         = Color(0xFFFF5252); // Neon Crimson
  static const Color orange      = Color(0xFFFF9100); // Vibrant Amber

  // Glassmorphic Helper Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x26FFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}