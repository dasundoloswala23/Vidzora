import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_unit_ids.dart';

/// Preloads interstitial ads and shows one every 3rd completed download.
class InterstitialAdService {
  InterstitialAd? _ad;
  int _downloadCount = 0;

  void preload() {
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  /// Call after a download completes. Every 3rd call shows the preloaded
  /// interstitial (if ready), then resets the counter and preloads the next.
  void registerDownloadCompleted() {
    _downloadCount++;
    if (_downloadCount >= 3) {
      _downloadCount = 0;
      _showIfReady();
    }
  }

  void _showIfReady() {
    final ad = _ad;
    if (ad == null) {
      preload();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        preload();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        preload();
      },
    );
    ad.show();
  }

  void dispose() {
    _ad?.dispose();
  }
}
