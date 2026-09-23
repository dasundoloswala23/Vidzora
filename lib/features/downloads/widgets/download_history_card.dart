import 'package:flutter/material.dart';
import '../../../core/constants/supported_platforms.dart';
import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/download_history_entry.dart';
import '../../../models/enums/media_type.dart';

/// A single row in the Downloads history list.
class DownloadHistoryCard extends StatelessWidget {
  const DownloadHistoryCard({super.key, required this.entry, this.onMorePressed});

  final DownloadHistoryEntry entry;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final platform = SupportedPlatforms.byId(entry.platform);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 46,
              height: 46,
              child: (entry.thumbnailUrl == null || entry.thumbnailUrl!.isEmpty)
                  ? _fallbackIcon(platform.color, entry.mediaType)
                  : Image.network(
                      entry.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          _fallbackIcon(platform.color, entry.mediaType),
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : _fallbackIcon(platform.color, entry.mediaType),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.format.toUpperCase()} · ${entry.quality}',
                  style: TextStyle(fontSize: 12, color: platform.color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.fileSize(entry.fileSizeBytes),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Formatters.relativeDate(entry.downloadedAt),
                style: TextStyle(fontSize: 11, color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: context.colors.onSurfaceVariant),
            onPressed: onMorePressed,
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(Color color, MediaType mediaType) {
    final icon = switch (mediaType) {
      MediaType.audio => Icons.music_note_rounded,
      MediaType.image => Icons.image_rounded,
      MediaType.video => Icons.videocam_rounded,
    };
    return Container(
      color: color.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: Icon(icon, color: color),
    );
  }
}
