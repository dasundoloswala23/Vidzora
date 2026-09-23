import 'package:flutter/material.dart';
import '../../../core/constants/supported_platforms.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extensions.dart';

/// Onboarding step 1 illustration: a phone mockup with placeholder lines
/// and a purple download button, plus a pill badge showing the supported
/// platform icons.
class IllustrationStep1 extends StatelessWidget {
  const IllustrationStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _line(context, width: 120),
              const SizedBox(height: 12),
              _line(context, width: 90),
              const SizedBox(height: 12),
              _line(context, width: 110),
              const SizedBox(height: 24),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPurple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.file_download_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final platform in SupportedPlatforms.all) ...[
                Icon(platform.icon, size: 14, color: platform.color),
                if (platform != SupportedPlatforms.all.last)
                  const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _line(BuildContext context, {required double width}) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: context.dividerColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
