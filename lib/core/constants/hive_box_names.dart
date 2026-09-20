/// Hive box and key names used across the app.
class HiveBoxNames {
  HiveBoxNames._();

  static const String settingsBox = 'settings_box';
  static const String settingsKey = 'settings';

  static const String downloadHistoryBox = 'download_history_box';

  static const String onboardingBox = 'onboarding_box';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';

  // Reuses the onboarding box as a general small "app flags" box.
  static const String hasRequestedReviewKey = 'has_requested_review';
}
