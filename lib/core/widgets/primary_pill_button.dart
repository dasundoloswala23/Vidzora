import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A full-width, fully-rounded pill button with an optional loading spinner.
class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !isLoading && onPressed != null;
    return ElevatedButton(
      onPressed: canTap ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.primaryPurple : AppColors.disabledGrey,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
            )
          : Text(label),
    );
  }
}
