/// Store identifiers used for update checks and review/rating prompts.
class StoreConfig {
  StoreConfig._();

  static const String androidPackageName = 'com.dasun.vidzora';

  // TODO: replace with the real numeric App Store id once the iOS app is
  // published (found in App Store Connect / the app's App Store URL).
  static const String iosAppStoreId = '';

  static String get androidPlayStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageName';

  static String get iosAppStoreUrl => 'https://apps.apple.com/app/id$iosAppStoreId';
}
