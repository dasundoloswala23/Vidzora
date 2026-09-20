import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/route_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/dot_page_indicator.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/vidzora_logo.dart';
import '../../providers/onboarding_providers.dart';

/// Full-screen purple gradient splash shown for ~2 seconds before routing
/// to onboarding or home depending on whether onboarding was seen.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(AppConstants.splashDuration, _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;
    final hasSeenOnboarding = ref.read(hasSeenOnboardingProvider);
    context.go(hasSeenOnboarding ? RoutePaths.home : RoutePaths.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              const VidzoraLogo(size: 108),
              const SizedBox(height: 24),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.tagline,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 15,
                ),
              ),
              const Spacer(flex: 4),
              const DotPageIndicator(count: 3, activeIndex: 0),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
