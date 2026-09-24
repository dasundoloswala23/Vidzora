import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_unit_ids.dart';
import 'ads_bootstrap.dart';

/// The outcome of [RewardedAdService.showAdAndAwaitReward].
enum RewardedAdResult {
  /// The ad played and the user earned the reward.
  earned,

  /// The ad played but was dismissed before the reward was earned.
  dismissedWithoutReward,

  /// No ad could be shown at all (SDK not ready, no fill, network issue).
  /// Callers treat this as "ads aren't supported right now" rather than a
  /// reason to block the feature the ad was gating.
  unavailable,
}

/// Manages loading and showing a rewarded ad, used to gate HD downloads.
class RewardedAdService {
  RewardedAd? _ad;
  bool _isLoading = false;
  bool _disposed = false;

  void preload() {
    if (_isLoading || _ad != null) return;
    _isLoading = true;
    AdsBootstrap.ensureInitialized().then((_) {
      if (_disposed) return;
      RewardedAd.load(
        adUnitId: AdUnitIds.rewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            if (_disposed) {
              ad.dispose();
              return;
            }
            _ad = ad;
            _isLoading = false;
          },
          onAdFailedToLoad: (error) {
            _ad = null;
            _isLoading = false;
            debugPrint('Rewarded ad failed to load: $error');
          },
        ),
      );
    });
  }

  Future<bool> _loadAndWait() async {
    await AdsBootstrap.ensureInitialized();
    final completer = Completer<bool>();
    RewardedAd.load(
      adUnitId: AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          if (!completer.isCompleted) completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );
    return completer.future;
  }

  /// Shows the rewarded ad. Always preloads the next ad after a shown ad is
  /// dismissed. See [RewardedAdResult] for how callers should treat each
  /// outcome — in particular, [RewardedAdResult.unavailable] is not a
  /// failure to gate on, since it means ads aren't working right now.
  Future<RewardedAdResult> showAdAndAwaitReward() async {
    if (_ad == null) {
      final loaded = await _loadAndWait();
      if (!loaded || _ad == null) {
        return RewardedAdResult.unavailable;
      }
    }

    final ad = _ad!;
    _ad = null;
    final rewardCompleter = Completer<RewardedAdResult>();
    var earnedReward = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(
            earnedReward ? RewardedAdResult.earned : RewardedAdResult.dismissedWithoutReward,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        preload();
        if (!rewardCompleter.isCompleted) {
          rewardCompleter.complete(RewardedAdResult.unavailable);
        }
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        earnedReward = true;
      },
    );

    return rewardCompleter.future;
  }

  void dispose() {
    _disposed = true;
    _ad?.dispose();
  }
}
