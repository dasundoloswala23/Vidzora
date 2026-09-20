import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Bottom navigation bar with a small active-dot indicator, matching the
/// Home / Downloads / Settings reference design.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.download_rounded, label: 'Downloads'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              final color = isActive
                  ? AppColors.primaryPurple
                  : theme.bottomNavigationBarTheme.unselectedItemColor;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: color, size: 24),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryPurple : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
