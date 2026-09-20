import 'package:flutter/material.dart';
import '../constants/supported_platforms.dart';

/// A pill chip showing a platform's icon and label in its brand color.
class PlatformChip extends StatelessWidget {
  const PlatformChip({super.key, required this.platform});

  final SupportedPlatform platform;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: platform.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(platform.icon, size: 16, color: platform.color),
          const SizedBox(width: 6),
          Text(
            platform.label,
            style: TextStyle(
              color: platform.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
