import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen purple gradient background used by the splash screen.
///
/// The size is explicit on purpose. This used to be a bare [Container] with
/// only a `decoration`, which shrink-wraps to its child whenever it receives
/// unbounded constraints — that rendered the gradient as a narrow left-aligned
/// strip the width of the logo/wordmark, with the Scaffold's own (white)
/// background filling the rest of the screen.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashGradientTop, AppColors.splashGradientBottom],
          ),
        ),
        child: child,
      ),
    );
  }
}
