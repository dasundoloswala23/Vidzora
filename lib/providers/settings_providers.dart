import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../models/enums/download_quality.dart';
import '../services/storage/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Holds and persists [AppSettings], writing to Hive on every mutation.
class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.read(settingsRepositoryProvider).load();
  }

  Future<void> _update(AppSettings settings) async {
    state = settings;
    await ref.read(settingsRepositoryProvider).save(settings);
  }

  Future<void> setDownloadQuality(DownloadQuality quality) =>
      _update(state.copyWith(downloadQuality: quality));

  Future<void> setAutoSave(bool value) => _update(state.copyWith(autoSave: value));

  Future<void> setWifiOnly(bool value) => _update(state.copyWith(wifiOnly: value));

  Future<void> setSaveToGallery(bool value) =>
      _update(state.copyWith(saveToGallery: value));

  Future<void> setThemeMode(ThemeMode mode) => _update(state.copyWith(themeMode: mode));
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appSettingsProvider).themeMode;
});
