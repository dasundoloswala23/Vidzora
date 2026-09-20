import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/ad_providers.dart';
import '../../../services/ads/ad_service.dart';

/// Displays a banner ad once loaded, or a grey placeholder container while
/// loading/failed, matching the reference design's ad placeholder slot.
class AdBannerSlot extends ConsumerStatefulWidget {
  const AdBannerSlot({super.key});

  @override
  ConsumerState<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends ConsumerState<AdBannerSlot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bannerAdServiceProvider).loadBanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adService = ref.watch(bannerAdServiceProvider);
    return AnimatedBuilder(
      animation: adService,
      builder: (context, _) {
        final bannerAd = adService.bannerAd;
        if (adService.state == BannerAdLoadState.loaded && bannerAd != null) {
          return SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
        }
        return Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.dividerGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Advertisement',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        );
      },
    );
  }
}
