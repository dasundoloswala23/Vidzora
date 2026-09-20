import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/store_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/update_available_dialog.dart';
import '../../models/enums/download_quality.dart';
import '../../providers/download_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/update_providers.dart';
import 'widgets/clear_history_row.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_toggle_row.dart';
import 'widgets/settings_value_row.dart';
import 'widgets/storage_usage_bar.dart';
import 'widgets/theme_segmented_control.dart';

/// Settings screen: General, Appearance, Storage, About and Support.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const double _assumedMaxStorageBytes = 100 * 1024 * 1024;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _pickQuality(BuildContext context, WidgetRef ref, DownloadQuality current) async {
    final selected = await showModalBottomSheet<DownloadQuality>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final quality in DownloadQuality.values)
              ListTile(
                title: Text(quality.label),
                trailing: quality == current
                    ? const Icon(Icons.check_rounded, color: AppColors.primaryPurple)
                    : null,
                onTap: () => Navigator.of(context).pop(quality),
              ),
          ],
        ),
      ),
    );
    if (selected != null) {
      await ref.read(appSettingsProvider.notifier).setDownloadQuality(selected);
    }
  }

  Future<void> _checkForUpdate(BuildContext context, WidgetRef ref) async {
    final updateService = ref.read(appUpdateServiceProvider);
    final result = await updateService.checkForUpdate();
    if (!context.mounted) return;

    if (!result.updateAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You're on the latest version.")),
      );
      return;
    }

    await UpdateAvailableDialog.show(
      context,
      storeVersion: result.storeVersion,
      onUpdate: () async {
        if (Platform.isAndroid) {
          if (result.androidImmediateAllowed) {
            await updateService.startAndroidImmediateUpdate();
          } else {
            await updateService.startAndroidFlexibleUpdate();
          }
        } else if (Platform.isIOS) {
          final uri = Uri.parse(result.storeUrl ?? StoreConfig.iosAppStoreUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  Future<void> _confirmClearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Download History'),
        content: const Text('This removes all download history and deletes local files. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear', style: TextStyle(color: AppColors.dangerRed)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(downloadHistoryProvider.notifier).clear();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final storageBytes = ref.watch(downloadHistoryProvider.notifier).computeStorageUsedBytes();
    final storageFraction = storageBytes / _assumedMaxStorageBytes;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            SettingsSection(
              label: 'General',
              children: [
                SettingsValueRow(
                  label: 'Download Quality',
                  value: settings.downloadQuality.label,
                  onTap: () => _pickQuality(context, ref, settings.downloadQuality),
                ),
                SettingsToggleRow(
                  label: 'Auto Save',
                  value: settings.autoSave,
                  onChanged: (v) => ref.read(appSettingsProvider.notifier).setAutoSave(v),
                ),
                SettingsToggleRow(
                  label: 'Wi-Fi Only',
                  value: settings.wifiOnly,
                  onChanged: (v) => ref.read(appSettingsProvider.notifier).setWifiOnly(v),
                ),
                SettingsToggleRow(
                  label: 'Save to Gallery',
                  value: settings.saveToGallery,
                  onChanged: (v) => ref.read(appSettingsProvider.notifier).setSaveToGallery(v),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              label: 'Appearance',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Theme', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                      ),
                      SizedBox(
                        width: 180,
                        child: ThemeSegmentedControl(
                          value: settings.themeMode,
                          onChanged: (mode) =>
                              ref.read(appSettingsProvider.notifier).setThemeMode(mode),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              label: 'Storage',
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Storage Used', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                          ),
                          Text(
                            '${(storageBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      StorageUsageBar(fraction: storageFraction),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                ClearHistoryRow(onClear: () => _confirmClearHistory(context, ref)),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              label: 'About',
              children: [
                SettingsValueRow(
                  label: 'Privacy Policy',
                  value: '',
                  showChevron: true,
                  onTap: () => _openUrl(AppConstants.privacyPolicyUrl),
                ),
                SettingsValueRow(
                  label: 'Terms of Use',
                  value: '',
                  showChevron: true,
                  onTap: () => _openUrl(AppConstants.termsOfUseUrl),
                ),
                SettingsValueRow(
                  label: 'About Vidzora',
                  value: '',
                  showChevron: true,
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                  ),
                ),
                const SettingsValueRow(
                  label: 'App Version',
                  value: AppConstants.appVersion,
                  valueColor: AppColors.textSecondary,
                ),
                SettingsValueRow(
                  label: 'Check for Updates',
                  value: '',
                  showChevron: true,
                  onTap: () => _checkForUpdate(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SettingsSection(
              label: 'Support',
              children: [
                SettingsValueRow(
                  label: 'Rate Vidzora',
                  value: '',
                  showChevron: true,
                  onTap: () => ref.read(reviewServiceProvider).requestReview(),
                ),
                SettingsValueRow(
                  label: 'Contact Us',
                  value: '',
                  showChevron: true,
                  labelColor: AppColors.dangerRed,
                  onTap: () => _openUrl('mailto:${AppConstants.contactEmail}'),
                ),
                SettingsValueRow(
                  label: 'Report a Problem',
                  value: '',
                  showChevron: true,
                  labelColor: AppColors.dangerRed,
                  onTap: () => _openUrl('mailto:${AppConstants.contactEmail}?subject=Problem%20Report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
