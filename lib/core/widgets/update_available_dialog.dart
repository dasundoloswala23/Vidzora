import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'primary_pill_button.dart';

/// A themed "Update Available" dialog shown when a newer store version is
/// detected. [onUpdate] performs the platform-appropriate action (Android:
/// starts the in-app update flow; iOS: opens the App Store page).
class UpdateAvailableDialog extends StatefulWidget {
  const UpdateAvailableDialog({super.key, required this.storeVersion, required this.onUpdate});

  final String? storeVersion;
  final Future<void> Function() onUpdate;

  static Future<void> show(
    BuildContext context, {
    required String? storeVersion,
    required Future<void> Function() onUpdate,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => UpdateAvailableDialog(storeVersion: storeVersion, onUpdate: onUpdate),
    );
  }

  @override
  State<UpdateAvailableDialog> createState() => _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends State<UpdateAvailableDialog> {
  bool _isUpdating = false;

  Future<void> _handleUpdate() async {
    setState(() => _isUpdating = true);
    await widget.onUpdate();
    if (mounted) setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.system_update_rounded,
                color: AppColors.primaryPurple,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Update Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              widget.storeVersion != null
                  ? 'Vidzora ${widget.storeVersion} is ready with the latest features and fixes.'
                  : 'A new version of Vidzora is ready to install.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            PrimaryPillButton(
              label: 'Update Now',
              isLoading: _isUpdating,
              onPressed: _handleUpdate,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: _isUpdating ? null : () => Navigator.of(context).pop(),
              child: const Text('Later', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
