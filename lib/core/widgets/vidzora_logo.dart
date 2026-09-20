import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The Vidzora logo rendered inside a rounded-rect container with a
/// soft purple glow, used on the splash screen and home app bar.
class VidzoraLogo extends StatelessWidget {
  const VidzoraLogo({super.key, this.size = 96, this.glow = true, this.borderRadius});

  final double size;
  final bool glow;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? size * 0.28;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.splashGradientTop.withValues(alpha: 0.45),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(size * 0.16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius * 0.6),
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.play_circle_fill_rounded,
            color: AppColors.primaryPurple,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}
