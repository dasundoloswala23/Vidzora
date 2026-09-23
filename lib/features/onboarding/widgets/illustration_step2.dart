import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extensions.dart';

/// Onboarding step 2 illustration: 3 stacked quality-option cards, with
/// HD selected (purple border + checkmark).
class IllustrationStep2 extends StatelessWidget {
  const IllustrationStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _qualityCard(
          context,
          badgeColor: AppColors.primaryPurple,
          title: 'HD Quality',
          subtitle: 'MP4 · 942×720',
          selected: true,
        ),
        const SizedBox(height: 10),
        _qualityCard(
          context,
          badgeColor: context.colors.onSurfaceVariant,
          title: 'MP4 Quality',
          subtitle: 'Standard · 480p',
          selected: false,
        ),
        const SizedBox(height: 10),
        _qualityCard(
          context,
          badgeColor: AppColors.successGreen,
          title: 'MP3 Quality',
          subtitle: 'Audio Only',
          selected: false,
        ),
      ],
    );
  }

  Widget _qualityCard(
    BuildContext context, {
    required Color badgeColor,
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primaryPurple : context.dividerColor,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded, color: AppColors.primaryPurple, size: 20),
        ],
      ),
    );
  }
}
