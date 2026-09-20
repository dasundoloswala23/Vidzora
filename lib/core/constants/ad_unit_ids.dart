import 'dart:io' show Platform;

/// AdMob unit identifiers.
///
/// These are the real, production AdMob IDs supplied by the app owner.
/// The same literal IDs are used for both Android and iOS since no
/// separate iOS-specific units were provided.
// TODO: swap in iOS-specific ad unit IDs once they are issued.
class AdUnitIds {
  AdUnitIds._();

  static const String _appId = 'ca-app-pub-6564803074312178~1978946947';
  static const String _banner = 'ca-app-pub-6564803074312178/5818778749';
  static const String _interstitial = 'ca-app-pub-6564803074312178/9566452069';
  static const String _rewarded = 'ca-app-pub-6564803074312178/2491661848';

  static String get appId => _appId;

  static String get banner {
    if (Platform.isAndroid || Platform.isIOS) return _banner;
    return _banner;
  }

  static String get interstitial {
    if (Platform.isAndroid || Platform.isIOS) return _interstitial;
    return _interstitial;
  }

  static String get rewarded {
    if (Platform.isAndroid || Platform.isIOS) return _rewarded;
    return _rewarded;
  }
}
