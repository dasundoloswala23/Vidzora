import 'package:flutter/material.dart';
import '../constants/supported_platforms.dart';

/// A pill chip showing a platform's icon and label in its brand color.
class PlatformChip extends StatelessWidget {
  const PlatformChip({super.key, required this.platform});

  final SupportedPlatform platform;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: platform.label,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: platform.color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: platform.color.withValues(alpha: 0.3)),
        ),
        child: Icon(platform.icon, size: 16, color: platform.color),
      ),
    );
  }
}
