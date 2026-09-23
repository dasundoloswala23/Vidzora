import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extensions.dart';

/// A settings row with a label on the left and a value (optionally with a
/// trailing chevron) on the right, tappable when [onTap] is provided.
class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = false,
    this.valueColor,
    this.labelColor,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? valueColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: labelColor ?? context.colors.onSurface),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.primaryPurple,
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: context.colors.onSurfaceVariant, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
