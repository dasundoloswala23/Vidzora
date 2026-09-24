import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/bootstrap.dart';
import '../../app/router/route_paths.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/vidzora_logo.dart';
import '../../providers/onboarding_providers.dart';

/// Purple gradient splash shown while [bootstrapServices] finishes, then
/// hands off to onboarding or home depending on whether onboarding was seen.
///
/// The route itself never animates (every route this screen can lead to is a
/// `NoTransitionPage` in `app_router.dart`), and this screen no longer runs
/// any full-screen exit animation of its own either — an earlier version
/// crossfaded the background via a layered `Stack`, which reproducibly
/// rendered only part of the screen width (a real Impeller/Simulator repaint
/// bug, not a screenshot artifact — verified at a fixed pixel boundary across
/// captures). Simplicity wins here: fade in on entry, then navigate directly.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _entranceFade =
      CurvedAnimation(parent: _entrance, curve: const Interval(0, 0.7, curve: Curves.easeOut));
  late final Animation<double> _logoScale = Tween<double>(begin: 0.82, end: 1.0)
      .animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack));

  /// Drives the progress bar sweep for as long as the splash is up.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _entrance.forward();
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
    // right as the hand-off lands.
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
    _entrance.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // Matches the gradient's top colour (and the native launch screen) so
        // that even if anything around the gradient ever fails to fill the
        // screen, the leftover area is brand purple rather than white.
        backgroundColor: AppColors.splashGradientTop,
        body: GradientBackground(
          child: SafeArea(
            child: FadeTransition(
              opacity: _entranceFade,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  ScaleTransition(scale: _logoScale, child: const _PulsingLogo()),
                  const SizedBox(height: 28),
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(flex: 4),
                  _SweepProgressBar(animation: _loop),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The logo inside a soft static glow ring.
class _PulsingLogo extends StatelessWidget {
  const _PulsingLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      height: 172,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          const VidzoraLogo(size: 104),
        ],
      ),
    );
  }
}

/// A thin indeterminate progress bar: a light track with a bright segment
/// sweeping across it, looped by the caller's [animation].
///
/// Deliberately self-contained and narrowly scoped (120x4px): its
/// `AnimatedBuilder` only rebuilds this small subtree, not the full screen.
class _SweepProgressBar extends StatelessWidget {
  const _SweepProgressBar({required this.animation});

  static const double _trackWidth = 120;
  static const double _segmentWidth = 48;

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _trackWidth,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          children: [
            const ColoredBox(color: Color(0x2EFFFFFF)),
            AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(animation.value);
                // Sweeps from fully off the left edge to fully off the right.
                final left = -_segmentWidth + t * (_trackWidth + _segmentWidth);
                return Positioned(
                  left: left,
                  width: _segmentWidth,
                  top: 0,
                  bottom: 0,
                  child: const ColoredBox(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
