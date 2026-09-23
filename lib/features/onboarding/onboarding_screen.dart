import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme_extensions.dart';
import '../../core/widgets/dot_page_indicator.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../../providers/onboarding_providers.dart';
import 'widgets/illustration_step1.dart';
import 'widgets/illustration_step2.dart';
import 'widgets/illustration_step3.dart';
import 'widgets/onboarding_page.dart';

/// The 3-page onboarding flow shown once before the user reaches Home.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    OnboardingPage(
      illustration: IllustrationStep1(),
      heading: 'Save Your Favorite Videos',
      subtext: 'Paste a supported social media link and quickly save your favorite media.',
    ),
    OnboardingPage(
      illustration: IllustrationStep2(),
      heading: 'Choose Your Quality',
      subtext: 'Select HD video, standard video, or audio when available.',
    ),
    OnboardingPage(
      illustration: IllustrationStep3(),
      heading: 'Save to Your Gallery',
      subtext: 'Download media and easily access it from your device.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(hasSeenOnboardingProvider.notifier).markSeen();
    if (mounted) context.go(RoutePaths.home);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _index == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: _pages,
              ),
            ),
            DotPageIndicator(
              count: _pages.length,
              activeIndex: _index,
              activeColor: AppColors.primaryPurple,
              inactiveColor: AppColors.disabledGrey,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryPillButton(
                label: isLastPage ? 'Get Started' : 'Next',
                onPressed: _next,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: isLastPage
                  ? null
                  : TextButton(
                      onPressed: _finish,
                      child: Text(
                        'Skip',
                        style: TextStyle(color: context.colors.onSurfaceVariant, fontSize: 14),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
