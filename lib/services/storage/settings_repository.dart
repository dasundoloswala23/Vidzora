import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../../models/app_settings.dart';

/// CRUD access to the single persisted [AppSettings] record.
class SettingsRepository {
  Box<AppSettings> get _box => Hive.box<AppSettings>(HiveBoxNames.settingsBox);

  AppSettings load() {
    return _box.get(HiveBoxNames.settingsKey) ?? const AppSettings();
  }

  Future<void> save(AppSettings settings) async {
    await _box.put(HiveBoxNames.settingsKey, settings);
  }
}
