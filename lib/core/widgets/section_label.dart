import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A small-caps grey section label, e.g. "SUPPORTED PLATFORMS" or "GENERAL".
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text, this.padding});

  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
