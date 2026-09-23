import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/vidzora_app.dart';
import 'core/constants/hive_box_names.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/app_settings.dart';
import 'models/download_history_entry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DownloadHistoryEntryAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  await Hive.openBox<DownloadHistoryEntry>(HiveBoxNames.downloadHistoryBox);
  await Hive.openBox<AppSettings>(HiveBoxNames.settingsBox);
  await Hive.openBox(HiveBoxNames.onboardingBox);

  await Future.wait<void>([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then<void>((_) {})
        .catchError((e) {
      debugPrint('Firebase init failed: $e');
    }),
    MobileAds.instance.initialize()
        .then<void>((_) {})
        .catchError((e) {
      debugPrint('MobileAds init failed: $e');
    }),
  ]);

  runApp(const ProviderScope(child: VidzoraApp()));
}
