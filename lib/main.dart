import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/bootstrap.dart';
import 'app/vidzora_app.dart';
import 'core/constants/hive_box_names.dart';
import 'models/app_settings.dart';
import 'models/download_history_entry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // These stay awaited: the onboarding flag is read synchronously by the
  // router's redirect on the very first route resolution. They're local-file
  // I/O, so single-digit milliseconds.
  await Hive.initFlutter();
  Hive.registerAdapter(DownloadHistoryEntryAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  await Hive.openBox<DownloadHistoryEntry>(HiveBoxNames.downloadHistoryBox);
  await Hive.openBox<AppSettings>(HiveBoxNames.settingsBox);
  await Hive.openBox(HiveBoxNames.onboardingBox);

  // Started but NOT awaited, so the first frame isn't gated on the ad SDK.
  // The splash awaits this instead.
  final bootstrap = bootstrapServices();

  runApp(
    ProviderScope(
      overrides: [bootstrapFutureProvider.overrideWithValue(bootstrap)],
      child: const VidzoraApp(),
    ),
  );
}
