/// General app-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Vidzora';
  static const String tagline = 'Save. Watch. Share.';

  /// How long the splash shows at minimum, so branding doesn't flicker past
  /// when startup happens to be fast. In practice this is the *only* thing
  /// the splash waits on, since the ad SDK no longer gates it.
  static const Duration splashMinDuration = Duration(milliseconds: 1200);

  /// Hard ceiling on the splash, so a slow Firebase init can never leave the
  /// user staring at it.
  static const Duration splashMaxDuration = Duration(seconds: 3);

  static const String privacyPolicyUrl = 'https://vidzora-85954.web.app/privacy.html';
  static const String termsOfUseUrl = 'https://vidzora-85954.web.app/terms.html';
  static const String contactEmail = 'dasundoloswala@gmail.com';
  static const String appVersion = '1.0.0';
}
