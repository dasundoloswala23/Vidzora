import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding step 3 illustration: a green checkmark badge and a
/// "Saved to Gallery!" pill.
class IllustrationStep3 extends StatelessWidget {
  const IllustrationStep3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.successGreen.withValues(alpha: 0.35),
                blurRadius: 30,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 72),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Saved to Gallery!',
            style: TextStyle(
              color: AppColors.successGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
