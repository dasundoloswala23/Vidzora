import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';

/// Persists whether the user has completed the onboarding flow.
class OnboardingRepository {
  Box get _box => Hive.box(HiveBoxNames.onboardingBox);

  bool get hasSeenOnboarding =>
      _box.get(HiveBoxNames.hasSeenOnboardingKey, defaultValue: false) as bool;

  Future<void> setHasSeenOnboarding(bool value) async {
    await _box.put(HiveBoxNames.hasSeenOnboardingKey, value);
  }
}
