import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/download_history_entry.dart';
import '../models/enums/media_type.dart';
import '../services/storage/download_history_repository.dart';

final downloadHistoryRepositoryProvider = Provider<DownloadHistoryRepository>((ref) {
  return DownloadHistoryRepository();
});

/// Holds the persisted list of download history entries.
class DownloadHistoryNotifier extends Notifier<List<DownloadHistoryEntry>> {
  @override
  List<DownloadHistoryEntry> build() {
    return ref.read(downloadHistoryRepositoryProvider).getAll();
  }

  Future<void> add(DownloadHistoryEntry entry) async {
    await ref.read(downloadHistoryRepositoryProvider).add(entry);
    state = ref.read(downloadHistoryRepositoryProvider).getAll();
  }

  Future<void> remove(String id) async {
    await ref.read(downloadHistoryRepositoryProvider).remove(id);
    state = ref.read(downloadHistoryRepositoryProvider).getAll();
  }

  Future<void> clear() async {
    await ref.read(downloadHistoryRepositoryProvider).clear();
    state = [];
  }

  int computeStorageUsedBytes() {
    return ref.read(downloadHistoryRepositoryProvider).computeStorageUsedBytes();
  }
}

final downloadHistoryProvider =
    NotifierProvider<DownloadHistoryNotifier, List<DownloadHistoryEntry>>(
  DownloadHistoryNotifier.new,
);

/// Currently selected filter on the Downloads screen: null = All.
final downloadFilterProvider = StateProvider<MediaType?>((ref) => null);

final filteredDownloadHistoryProvider = Provider<List<DownloadHistoryEntry>>((ref) {
  final filter = ref.watch(downloadFilterProvider);
  final all = ref.watch(downloadHistoryProvider);
  if (filter == null) return all;
  return all.where((e) => e.mediaType == filter).toList();
});

/// Tracks download progress (0.0-1.0) keyed by media item URL.
class ActiveDownloadsNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => {};

  void setProgress(String url, double progress) {
    state = {...state, url: progress};
  }

  void clear(String url) {
    final next = {...state}..remove(url);
    state = next;
  }
}

final activeDownloadsProvider =
    NotifierProvider<ActiveDownloadsNotifier, Map<String, double>>(
  ActiveDownloadsNotifier.new,
);

final activeDownloadProgressProvider = Provider.family<double?, String>((ref, url) {
  return ref.watch(activeDownloadsProvider)[url];
});
