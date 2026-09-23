import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../core/constants/api_config.dart';

/// The base URL + API key to use for the download API, for one platform.
class ApiPlatformConfig {
  const ApiPlatformConfig({required this.baseUrl, required this.apiKey});

  final String baseUrl;
  final String apiKey;

  bool get isConfigured => baseUrl.isNotEmpty && apiKey.isNotEmpty;
}

/// Fetches the real download-API base URL + key from the `app_config/api`
/// Firestore document (separate `android_*` / `ios_*` fields), so the
/// endpoint/key can be changed without shipping a new app build.
///
/// Falls back to the local [ApiConfig] placeholder if Firestore is
/// unreachable or the document/fields are missing.
class RemoteApiConfigService {
  RemoteApiConfigService({FirebaseFirestore? firestore}) : _injected = firestore;

  /// Resolved lazily inside [getConfig]'s `try` rather than in the initializer
  /// list: Firebase init is no longer awaited before `runApp` and can time out,
  /// and `FirebaseFirestore.instance` throws `[core/no-app]` when it hasn't
  /// initialized. Resolving it here lets that degrade to [_fallback].
  final FirebaseFirestore? _injected;

  ApiPlatformConfig? _cached;

  Future<ApiPlatformConfig> getConfig({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null) return _cached!;

    try {
      final firestore = _injected ??
          (Firebase.apps.isEmpty ? null : FirebaseFirestore.instance);
      if (firestore == null) return _fallback;

      final snapshot = await firestore.collection('app_config').doc('api').get();
      final data = snapshot.data();
      if (data == null) return _fallback;

      final isIos = Platform.isIOS;
      final url = (data[isIos ? 'ios_url' : 'android_url'] as String?)?.trim() ?? '';
      final key = (data[isIos ? 'ios_api_key' : 'android_api_key'] as String?)?.trim() ?? '';

      final config = (url.isEmpty || key.isEmpty)
          ? _fallback
          : ApiPlatformConfig(baseUrl: url, apiKey: key);

      _cached = config;
      return config;
    } catch (_) {
      return _fallback;
    }
  }

  static const ApiPlatformConfig _fallback =
      ApiPlatformConfig(baseUrl: ApiConfig.baseUrl, apiKey: ApiConfig.apiKey);
}
