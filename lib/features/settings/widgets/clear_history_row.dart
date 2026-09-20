import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// "Clear Download History" row with a red "Clear" action on the right.
class ClearHistoryRow extends StatelessWidget {
  const ClearHistoryRow({super.key, required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Clear Download History',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: onClear,
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
