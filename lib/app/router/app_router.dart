import 'package:flutter/foundation.dart';
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

/// Notifies go_router to re-run its `redirect` when [hasSeenOnboardingProvider]
/// changes, without recreating the [GoRouter] instance itself (see
/// [appRouterProvider] for why that distinction matters).
class _OnboardingRefreshListenable extends ChangeNotifier {
  _OnboardingRefreshListenable(Ref ref) {
    ref.listen<bool>(hasSeenOnboardingProvider, (_, _) => notifyListeners());
  }
}

/// Builds the app's [GoRouter] exactly once (this provider deliberately
/// never `ref.watch`es anything, so it never rebuilds). A fresh [GoRouter]
/// jumps back to [RoutePaths.splash] on construction, so recreating it every
/// time onboarding state changed used to bounce the user back to the splash
/// screen right after finishing onboarding. Instead, [_OnboardingRefreshListenable]
/// tells this same long-lived router to just re-run `redirect`.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _OnboardingRefreshListenable(ref);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final hasSeenOnboarding = ref.read(hasSeenOnboardingProvider);
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
