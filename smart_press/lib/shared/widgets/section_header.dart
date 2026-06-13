// lib/shared/widgets/section_header.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.accent2)),
          if (subtitle != null)
            Text(subtitle!,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSub)),
        ],
      ),
    );
  }
}