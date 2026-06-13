// lib/shared/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool outline;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accent;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: outline
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: bg, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(label,
                  style: TextStyle(
                      color: bg,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(label),
            ),
    );
  }
}