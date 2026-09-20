import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A 3-segment pill control for System / Light / Dark theme selection.
class ThemeSegmentedControl extends StatelessWidget {
  const ThemeSegmentedControl({super.key, required this.value, required this.onChanged});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  static const _options = [
    (mode: ThemeMode.system, label: 'System'),
    (mode: ThemeMode.light, label: 'Light'),
    (mode: ThemeMode.dark, label: 'Dark'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLavender,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          for (final option in _options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option.mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: value == option.mode ? AppColors.primaryPurple : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: value == option.mode ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
