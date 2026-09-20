import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A settings row with a label and a trailing [Switch].
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primaryPurple),
        ],
      ),
    );
  }
}
