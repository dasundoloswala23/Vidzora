import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The Vidzora logo rendered inside a rounded-rect container with a
/// soft purple glow, used on the splash screen and home app bar.
class VidzoraLogo extends StatelessWidget {
  const VidzoraLogo({super.key, this.size = 96, this.glow = true, this.borderRadius});

  final double size;
  final bool glow;
  final double? borderRadius;

  /// The image provider for a logo rendered at [size] on a [dpr] display.
  ///
  /// The source asset is 1254x1254 but never renders larger than ~108dp, so
  /// decoding it at full size wastes ~32x the memory and stalls the first
  /// frame. Callers that want to `precacheImage` MUST go through this so they
  /// produce the same cache key the widget renders with — otherwise the
  /// precache populates a different entry and does nothing.
  static ImageProvider providerFor(double size, double dpr) {
    // The image sits inside `padding: size * 0.16` on each side.
    final px = (size * 0.68 * dpr).ceil();
    return ResizeImage(
      const AssetImage('assets/logo.png'),
      width: px,
      height: px,
      policy: ResizeImagePolicy.fit,
    );
  }

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
        child: Image(
          image: providerFor(size, MediaQuery.devicePixelRatioOf(context)),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
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
