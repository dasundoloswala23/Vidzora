import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_unit_ids.dart';
import 'ads_bootstrap.dart';

enum BannerAdLoadState { loading, loaded, failed }

/// Manages loading and lifecycle of a single [BannerAd].
class AdService extends ChangeNotifier {
  BannerAd? _bannerAd;
  BannerAdLoadState _state = BannerAdLoadState.loading;
  bool _disposed = false;

  BannerAd? get bannerAd => _bannerAd;
  BannerAdLoadState get state => _state;

  void loadBanner() {
    _bannerAd?.dispose();
    _state = BannerAdLoadState.loading;
    notifyListeners();

    AdsBootstrap.ensureInitialized().then((_) {
      if (_disposed) return;

      final ad = BannerAd(
        adUnitId: AdUnitIds.banner,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (_disposed) {
              ad.dispose();
              return;
            }
            _bannerAd = ad as BannerAd;
            _state = BannerAdLoadState.loaded;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (_disposed) return;
            _state = BannerAdLoadState.failed;
            notifyListeners();
          },
        ),
      );
      ad.load();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _bannerAd?.dispose();
    super.dispose();
  }
}
