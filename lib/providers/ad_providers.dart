import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ads/ad_service.dart';
import '../services/ads/interstitial_ad_service.dart';
import '../services/ads/rewarded_ad_service.dart';

final bannerAdServiceProvider = Provider<AdService>((ref) {
  final service = AdService();
  ref.onDispose(service.dispose);
  return service;
});

final interstitialAdServiceProvider = Provider<InterstitialAdService>((ref) {
  final service = InterstitialAdService();
  service.preload();
  ref.onDispose(service.dispose);
  return service;
});

final rewardedAdServiceProvider = Provider<RewardedAdService>((ref) {
  final service = RewardedAdService();
  service.preload();
  ref.onDispose(service.dispose);
  return service;
});
