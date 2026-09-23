import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../firebase_options.dart';

/// Starts the SDKs that aren't needed for the first frame.
///
/// Returns only the part the splash should wait on. Firebase is included
/// because [RemoteApiConfigService] needs it for the download endpoint, and
/// it's fast (local init, no network round-trip). MobileAds is deliberately
/// NOT awaited: it routinely takes 1-3s on a real device, and nothing on Home
/// requires it — the banner slot shows a placeholder until it loads.
///
/// Never throws and never hangs, so the splash can't be stranded.
Future<void> bootstrapServices() {
  // Fire-and-forget; finishes while the user is already on Home.
  unawaited(
    MobileAds.instance
        .initialize()
        .then<void>((_) {})
        .catchError((Object e) => debugPrint('MobileAds init failed: $e')),
  );

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
