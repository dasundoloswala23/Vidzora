import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';

/// Tracks whether the app has already auto-prompted the user for a review,
/// so the automatic prompt (unlike the manual "Rate Vidzora" settings row)
/// only ever fires once per install.
class ReviewPromptRepository {
  Box get _box => Hive.box(HiveBoxNames.onboardingBox);

  bool get hasRequestedReview =>
      _box.get(HiveBoxNames.hasRequestedReviewKey, defaultValue: false) as bool;

  Future<void> markRequested() async {
    await _box.put(HiveBoxNames.hasRequestedReviewKey, true);
  }
}
