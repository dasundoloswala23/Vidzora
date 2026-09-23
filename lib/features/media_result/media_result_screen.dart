import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../models/media_item.dart';
import '../../providers/api_providers.dart';
import 'widgets/media_item_tile.dart';

/// Shows the fetched media info (thumbnail, title) and the list of
/// downloadable [MediaItem]s, pushed on top of the shell (no bottom nav).
class MediaResultScreen extends ConsumerWidget {
  const MediaResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mediaFetchControllerProvider);
    final response = state.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Download Options')),
      body: response == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        response.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          color: AppColors.dividerGrey,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_rounded, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          response.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 20),
                        color: AppColors.textSecondary,
                        tooltip: 'Copy title & hashtags',
                        visualDensity: VisualDensity.compact,
                        onPressed: response.title.isEmpty
                            ? null
                            : () => _copyTitle(context, response.title),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    response.uniqueId,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Downloads',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final item in response.medias)
                    MediaItemTile(
                      item: item,
                      sourceTitle: response.title,
                      platform: response.source,
                      sourceUrl: response.id,
                      thumbnailUrl: response.thumbnail,
                    ),
                  if (response.thumbnail.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Thumbnail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MediaItemTile(
                      item: MediaItem.thumbnail(response.thumbnail),
                      sourceTitle: response.title,
                      platform: response.source,
                      sourceUrl: response.id,
                      thumbnailUrl: response.thumbnail,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Future<void> _copyTitle(BuildContext context, String title) async {
    await Clipboard.setData(ClipboardData(text: title));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard.'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }
}
