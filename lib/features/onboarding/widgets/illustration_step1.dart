import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding step 1 illustration: a phone mockup with placeholder lines
/// and a purple download button, plus a "TikTok · Instagram" pill badge.
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
            color: AppColors.surfaceWhite,
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
              _line(width: 120),
              const SizedBox(height: 12),
              _line(width: 90),
              const SizedBox(height: 12),
              _line(width: 110),
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
          child: const Text(
            'TikTok · Instagram',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _line({required double width}) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: AppColors.dividerGrey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
