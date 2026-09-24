import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_unit_ids.dart';
import 'ads_bootstrap.dart';

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

  /// Shows the rewarded ad and resolves `true` only if the user earned the
  /// reward before the ad was dismissed. Always preloads the next ad after.
  Future<bool> showAdAndAwaitReward() async {
    if (_ad == null) {
      final loaded = await _loadAndWait();
      if (!loaded || _ad == null) {
        return false;
      }
    }

    final ad = _ad!;
    _ad = null;
    final rewardCompleter = Completer<bool>();
    var earnedReward = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preload();
        if (!rewardCompleter.isCompleted) rewardCompleter.complete(earnedReward);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        preload();
        if (!rewardCompleter.isCompleted) rewardCompleter.complete(false);
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
