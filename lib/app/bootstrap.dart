import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase_options.dart';

/// Starts Firebase, which [RemoteApiConfigService] needs for the download
/// endpoint. Fast (local init, no network round-trip), so the splash can
/// afford to wait for it.
///
/// The ad SDK is deliberately NOT started here — see [AdsBootstrap] in
/// `services/ads/ads_bootstrap.dart` for why initializing it this early
/// caused startup hangs on real devices.
///
/// Never throws and never hangs, so the splash can't be stranded.
Future<void> bootstrapServices() {
  return Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then<void>((_) {})
      .timeout(const Duration(seconds: 3), onTimeout: () {})
      .catchError((Object e) => debugPrint('Firebase init failed: $e'));
}

/// The in-flight [bootstrapServices] future, overridden in `main()` so the
/// work starts before `runApp` and runs exactly once.
final bootstrapFutureProvider = Provider<Future<void>>(
  (ref) => throw UnimplementedError('bootstrapFutureProvider must be overridden in main()'),
);
