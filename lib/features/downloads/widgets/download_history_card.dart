import 'package:flutter/material.dart';
import '../../../core/constants/supported_platforms.dart';
import '../../../core/theme/app_colors.dart';
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
    final isAudio = entry.mediaType == MediaType.audio;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
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
                  ? _fallbackIcon(platform.color, isAudio)
                  : Image.network(
                      entry.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) =>
                          _fallbackIcon(platform.color, isAudio),
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : _fallbackIcon(platform.color, isAudio),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${platform.label} · ${entry.format.toUpperCase()} · ${entry.quality}',
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Formatters.relativeDate(entry.downloadedAt),
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
            onPressed: onMorePressed,
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(Color color, bool isAudio) {
    return Container(
      color: color.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: Icon(
        isAudio ? Icons.music_note_rounded : Icons.videocam_rounded,
        color: color,
      ),
    );
  }
}
