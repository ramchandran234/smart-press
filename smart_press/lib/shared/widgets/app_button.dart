// lib/shared/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool outline;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.outline = false,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.color ?? AppColors.accent;
    final isDarkText = bg == AppColors.accent || bg == AppColors.green || bg == AppColors.gold;
    final textColor = widget.outline ? bg : (isDarkText ? AppColors.darkBg : AppColors.white);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: widget.outline ? Colors.transparent : bg,
              borderRadius: BorderRadius.circular(16),
              border: widget.outline
                  ? Border.all(color: bg, width: 2)
                  : Border.all(color: Colors.white.withOpacity(0.15), width: 1),
              boxShadow: widget.outline || _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: bg.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: textColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}