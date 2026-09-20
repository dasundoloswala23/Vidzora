import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/constants/store_config.dart';

/// The result of an update check, normalized across Android/iOS.
class UpdateCheckResult {
  const UpdateCheckResult({
    required this.updateAvailable,
    this.storeVersion,
    this.storeUrl,
    this.androidImmediateAllowed = false,
  });

  final bool updateAvailable;
  final String? storeVersion;

  /// Only set on iOS - the App Store page to open for the update.
  final String? storeUrl;

  /// Android only - whether Play Core allows an in-app "immediate" (blocking)
  /// update flow for this update, vs. only a "flexible" (background) one.
  final bool androidImmediateAllowed;
}

/// Checks for and (on Android) performs in-app updates.
///
/// - Android: uses Play Core's in-app update API. Only returns an update
///   when the app was installed from the Play Store, so this is a safe
///   no-op during development/sideloading.
/// - iOS: Apple has no in-app update API, so this looks the app up on the
///   App Store (by bundle id) and compares versions; the caller is
///   responsible for sending the user to [UpdateCheckResult.storeUrl].
class AppUpdateService {
  AppUpdateService({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Future<UpdateCheckResult> checkForUpdate() async {
    if (Platform.isAndroid) return _checkAndroid();
    if (Platform.isIOS) return _checkIOS();
    return const UpdateCheckResult(updateAvailable: false);
  }

  Future<UpdateCheckResult> _checkAndroid() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      return UpdateCheckResult(
        updateAvailable: info.updateAvailability == UpdateAvailability.updateAvailable,
        storeVersion: info.availableVersionCode?.toString(),
        androidImmediateAllowed: info.immediateUpdateAllowed,
      );
    } catch (_) {
      // Not installed from Play Store, offline, Play services unavailable, etc.
      return const UpdateCheckResult(updateAvailable: false);
    }
  }

  Future<UpdateCheckResult> _checkIOS() async {
    if (StoreConfig.iosAppStoreId.isEmpty) return const UpdateCheckResult(updateAvailable: false);
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final uri = Uri.parse('https://itunes.apple.com/lookup?bundleId=${packageInfo.packageName}');
      final response = await _http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return const UpdateCheckResult(updateAvailable: false);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return const UpdateCheckResult(updateAvailable: false);

      final entry = results.first as Map<String, dynamic>;
      final storeVersion = entry['version'] as String?;
      final storeUrl = entry['trackViewUrl'] as String?;
      if (storeVersion == null) return const UpdateCheckResult(updateAvailable: false);

      final isNewer = _isVersionNewer(current: packageInfo.version, store: storeVersion);
      return UpdateCheckResult(
        updateAvailable: isNewer,
        storeVersion: storeVersion,
        storeUrl: storeUrl ?? StoreConfig.iosAppStoreUrl,
      );
    } catch (_) {
      return const UpdateCheckResult(updateAvailable: false);
    }
  }

  bool _isVersionNewer({required String current, required String store}) {
    final c = current.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final s = store.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final len = c.length > s.length ? c.length : s.length;
    for (var i = 0; i < len; i++) {
      final cv = i < c.length ? c[i] : 0;
      final sv = i < s.length ? s[i] : 0;
      if (sv > cv) return true;
      if (sv < cv) return false;
    }
    return false;
  }

  /// Starts Play Core's "immediate" (blocking, full-screen) update flow.
  Future<void> startAndroidImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (_) {
      // User cancelled or the flow failed - nothing to recover here.
    }
  }

  /// Starts Play Core's "flexible" (background download) update flow, then
  /// prompts to install once the download completes.
  Future<void> startAndroidFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (_) {
      // User cancelled or the flow failed - nothing to recover here.
    }
  }
}
