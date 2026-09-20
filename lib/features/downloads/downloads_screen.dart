import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../providers/download_providers.dart';
import 'widgets/download_history_card.dart';
import 'widgets/filter_chip_bar.dart';

/// Downloads screen: filter chips + scrollable download history list.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(downloadFilterProvider);
    final entries = ref.watch(filteredDownloadHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilterChipBar(
                selected: filter,
                onChanged: (value) => ref.read(downloadFilterProvider.notifier).state = value,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: entries.isEmpty
                  ? const EmptyState(
                      icon: Icons.download_rounded,
                      title: 'No downloads yet',
                      subtitle: 'Media you download will show up here.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return DownloadHistoryCard(
                          entry: entry,
                          onMorePressed: () => _showOptions(context, ref, entry.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref, String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.dangerRed),
              title: const Text('Remove from history'),
              onTap: () {
                ref.read(downloadHistoryProvider.notifier).remove(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
