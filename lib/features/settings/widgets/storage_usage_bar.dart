import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A thin horizontal progress bar showing storage usage, purple fill on a
/// light-grey track.
class StorageUsageBar extends StatelessWidget {
  const StorageUsageBar({super.key, required this.fraction});

  /// 0.0 - 1.0
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        minHeight: 6,
        backgroundColor: AppColors.dividerGrey,
        valueColor: const AlwaysStoppedAnimation(AppColors.primaryPurple),
      ),
    );
  }
}
