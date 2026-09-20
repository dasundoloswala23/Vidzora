import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A single onboarding page: illustration + heading + subtext.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.illustration,
    required this.heading,
    required this.subtext,
  });

  final Widget illustration;
  final String heading;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 40),
          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtext,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
