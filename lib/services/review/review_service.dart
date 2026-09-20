import 'package:in_app_review/in_app_review.dart';
import '../../core/constants/store_config.dart';

/// Wraps the native in-app review prompt (Play Store / App Store).
///
/// Both platforms self-throttle how often the native prompt can actually
/// appear (Android via Play Core quotas, iOS via `SKStoreReviewController`,
/// capped around 3 times/year), so this is safe to call without extra
/// server-side rate limiting - the app just avoids calling it too eagerly
/// (see `hasRequestedReview` gating in [ReviewPromptRepository]).
class ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    } else {
      await openStoreListing();
    }
  }

  Future<void> openStoreListing() {
    return _inAppReview.openStoreListing(
      appStoreId: StoreConfig.iosAppStoreId.isEmpty ? null : StoreConfig.iosAppStoreId,
    );
  }
}
