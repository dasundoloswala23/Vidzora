// Startup/navigation tests.
//
// The onboarding -> home hop is deliberately driven *only* by the router's
// redirect (OnboardingScreen._finish no longer calls context.go), so the
// second test guards that: if the refreshListenable wiring ever regresses,
// onboarding would dead-end and this fails.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import 'package:vidzora/app/bootstrap.dart';
import 'package:vidzora/app/router/app_router.dart';
import 'package:vidzora/app/router/route_paths.dart';
import 'package:vidzora/app/vidzora_app.dart';
import 'package:vidzora/core/constants/hive_box_names.dart';
import 'package:vidzora/models/app_settings.dart';
import 'package:vidzora/models/download_history_entry.dart';
import 'package:vidzora/providers/ad_providers.dart';
import 'package:vidzora/providers/onboarding_providers.dart';
import 'package:vidzora/services/ads/ad_service.dart';

class _NoopAdService extends AdService {
  @override
  void loadBanner() {}
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vidzora_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DownloadHistoryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    await Hive.openBox<DownloadHistoryEntry>(HiveBoxNames.downloadHistoryBox);
    await Hive.openBox<AppSettings>(HiveBoxNames.settingsBox);
    await Hive.openBox(HiveBoxNames.onboardingBox);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        // Bootstrap is already complete, so the splash only waits out its
        // minimum display duration.
        bootstrapFutureProvider.overrideWithValue(Future<void>.value()),
        // Home loads a banner on its first frame; the real SDK isn't
        // available under `flutter test` and leaves the tree busy forever.
        bannerAdServiceProvider.overrideWith((ref) => _NoopAdService()),
      ],
      child: const VidzoraApp(),
    );
  }

  testWidgets('boots and shows the splash screen', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.text('Vidzora'), findsOneWidget);

    // Drain the splash's pending navigation timer; tests fail on leftovers.
    await settleRoute(tester);
  });

  testWidgets('splash routes to onboarding when it has not been seen',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump();

    final router = routerOf(tester);

    await settleRoute(tester);

    expect(currentPath(router), RoutePaths.onboarding);
  });

  testWidgets('marking onboarding seen redirects to home', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump();

    final router = routerOf(tester);

    await settleRoute(tester);
    expect(currentPath(router), RoutePaths.onboarding);

    // This is all OnboardingScreen._finish() does — no explicit navigation.
    // If the refreshListenable wiring regresses, onboarding dead-ends here.
    // runAsync because markSeen writes to Hive, and real disk I/O can't
    // complete inside testWidgets' fake-async zone.
    await tester.runAsync(
      () => container(tester).read(hasSeenOnboardingProvider.notifier).markSeen(),
    );
    await settleRoute(tester);

    expect(currentPath(router), RoutePaths.home);
  });
}

ProviderContainer container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(VidzoraApp)));

GoRouter routerOf(WidgetTester tester) => container(tester).read(appRouterProvider);

/// Advances past the splash's minimum display and the 350ms route fade.
///
/// Uses bounded pumps rather than `pumpAndSettle` because Home kicks off a
/// banner-ad load and an update check, whose plugins aren't available under
/// `flutter test` — the tree never goes quiet and the plugins throw. Those
/// exceptions are irrelevant to routing, so they're drained.
Future<void> settleRoute(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
  tester.takeException();
}

String currentPath(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;
