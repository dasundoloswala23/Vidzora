import 'dart:io';
import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../../models/download_history_entry.dart';
import '../../models/enums/media_type.dart';

/// CRUD access to the persisted list of [DownloadHistoryEntry] records.
class DownloadHistoryRepository {
  Box<DownloadHistoryEntry> get _box =>
      Hive.box<DownloadHistoryEntry>(HiveBoxNames.downloadHistoryBox);

  List<DownloadHistoryEntry> getAll() {
    final values = _box.values.toList();
    values.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
    return values;
  }

  List<DownloadHistoryEntry> getByType(MediaType? type) {
    final all = getAll();
    if (type == null) return all;
    return all.where((e) => e.mediaType == type).toList();
  }

  Future<void> add(DownloadHistoryEntry entry) async {
    await _box.put(entry.id, entry);
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    for (final entry in _box.values) {
      try {
        final file = File(entry.localFilePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Best-effort file cleanup; ignore failures.
      }
    }
    await _box.clear();
  }

  int computeStorageUsedBytes() {
    return _box.values.fold<int>(0, (sum, e) => sum + e.fileSizeBytes);
  }
}
