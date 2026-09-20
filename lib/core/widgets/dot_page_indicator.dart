import 'package:flutter/material.dart';

/// A row of dots where the active dot is wider, used for splash and
/// onboarding page indicators.
class DotPageIndicator extends StatelessWidget {
  const DotPageIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white24,
    this.dotHeight = 8,
  });

  final int count;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? dotHeight * 3 : dotHeight,
          height: dotHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotHeight),
          ),
        );
      }),
    );
  }
}
