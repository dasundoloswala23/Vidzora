import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/bootstrap.dart';
import '../../app/router/route_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/dot_page_indicator.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/vidzora_logo.dart';
import '../../providers/onboarding_providers.dart';

/// Full-screen purple gradient splash shown while [bootstrapServices] finishes,
/// then routes to onboarding or home depending on whether onboarding was seen.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  late final Animation<double> _scale =
      Tween<double>(begin: 0.92, end: 1.0).animate(_fade);

  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _run();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    // Warm the *home app bar* size (32), not the splash's own 108: the 108
    // variant is needed on this screen's first frame, so precaching it here
    // would be too late to help. This stops the logo popping in on Home
    // right as the cross-fade lands.
    precacheImage(
      VidzoraLogo.providerFor(32, MediaQuery.devicePixelRatioOf(context)),
      context,
    );
  }

  Future<void> _run() async {
    final minDisplay = Future<void>.delayed(AppConstants.splashMinDuration);
    // Already non-throwing and individually timed out; the ceiling below is
    // belt-and-braces so a hung SDK can never strand the user here.
    final init = ref.read(bootstrapFutureProvider);
    await Future.wait<void>([minDisplay, init])
        .timeout(AppConstants.splashMaxDuration, onTimeout: () => const <void>[]);

    if (!mounted) return;
    final hasSeenOnboarding = ref.read(hasSeenOnboardingProvider);
    context.go(hasSeenOnboarding ? RoutePaths.home : RoutePaths.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
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
          ),
        ),
      ),
    );
  }
}
