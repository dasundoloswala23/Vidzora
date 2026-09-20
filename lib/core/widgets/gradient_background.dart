import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen purple gradient background used by the splash screen.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.splashGradientTop, AppColors.splashGradientBottom],
        ),
      ),
      child: child,
    );
  }
}
