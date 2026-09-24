import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Lazily initializes the Mobile Ads SDK at most once, on first actual ad
/// request rather than eagerly from `main()`.
///
/// Starting it before `runApp` had it competing with UIKit's teardown of the
/// native launch screen and Flutter's earliest frames for main-thread time on
/// real devices — the native SDK's own startup work (network calls, consent
/// checks) could stall rendering right at the splash's exit. Every ad entry
/// point (banner, interstitial, rewarded) now awaits this first instead,
/// which only runs once the relevant screen has already mounted.
class AdsBootstrap {
  AdsBootstrap._();

  static Future<InitializationStatus>? _future;

  static Future<void> ensureInitialized() {
    return (_future ??= MobileAds.instance.initialize());
  }
}
