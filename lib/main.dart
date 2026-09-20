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

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  await MobileAds.instance.initialize();

  runApp(const ProviderScope(child: VidzoraApp()));
}
