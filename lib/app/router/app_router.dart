import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/downloads/downloads_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/media_result/media_result_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/root_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../providers/onboarding_providers.dart';
import 'route_paths.dart';

/// Builds the app's [GoRouter]. Rebuilt whenever [hasSeenOnboardingProvider]
/// changes, so its redirect logic always reflects the latest onboarding
/// state (per the Riverpod + go_router refresh pattern).
final appRouterProvider = Provider<GoRouter>((ref) {
  final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final path = state.matchedLocation;

      if (path == RoutePaths.splash) return null;

      if (!hasSeenOnboarding && path != RoutePaths.onboarding) {
        return RoutePaths.onboarding;
      }

      if (hasSeenOnboarding && path == RoutePaths.onboarding) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.mediaResult,
        builder: (context, state) => const MediaResultScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.downloads,
                builder: (context, state) => const DownloadsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
