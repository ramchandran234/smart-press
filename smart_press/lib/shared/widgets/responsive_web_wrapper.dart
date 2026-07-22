// lib/shared/widgets/responsive_web_wrapper.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ResponsiveWebWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWebWrapper({
    super.key,
    required this.child,
    this.maxWidth = 560,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    if (!isDesktop) {
      return child;
    }

    return Material(
      color: AppColors.bgLight,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgLight,
          gradient: LinearGradient(
            colors: [Color(0xFF070A1E), Color(0xFF0F1535), Color(0xFF141C48)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.15),
                      blurRadius: 36,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
