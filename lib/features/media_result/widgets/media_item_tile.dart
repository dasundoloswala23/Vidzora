import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/download_history_entry.dart';
import '../../../models/enums/media_type.dart';
import '../../../models/media_item.dart';
import '../../../providers/ad_providers.dart';
import '../../../providers/download_providers.dart';
import '../../../providers/settings_providers.dart';
import '../../../providers/update_providers.dart';
import '../../../services/download/download_service.dart';
import '../../../services/gallery/gallery_service.dart';

/// A single downloadable [MediaItem] row shown on the media result screen.
///
/// Tapping "Save" on an HD video item requires watching a rewarded ad first
/// (ad-gating business logic); SD video and audio items download directly.
class MediaItemTile extends ConsumerStatefulWidget {
  const MediaItemTile({
    super.key,
    required this.item,
    required this.sourceTitle,
    required this.platform,
    required this.sourceUrl,
    this.thumbnailUrl,
  });

  final MediaItem item;
  final String sourceTitle;
  final String platform;
  final String sourceUrl;
  final String? thumbnailUrl;

  @override
  ConsumerState<MediaItemTile> createState() => _MediaItemTileState();
}

class _MediaItemTileState extends ConsumerState<MediaItemTile> {
  bool _isBusy = false;

  Future<void> _onSavePressed() async {
    final item = widget.item;

    if (item.isHd) {
      final proceed = await _showHdAdDialog();
      if (proceed != true) return;

      setState(() => _isBusy = true);
      final earned = await ref.read(rewardedAdServiceProvider).showAdAndAwaitReward();
      if (!mounted) return;

      if (!earned) {
        setState(() => _isBusy = false);
        _showMessage('Ad unavailable or not completed. HD download cancelled.', isError: true);
        return;
      }
    } else {
      setState(() => _isBusy = true);
    }

    await _download();
  }

  Future<bool?> _showHdAdDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlock HD Download'),
        content: const Text('Watch a short ad to unlock this HD download.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  Future<void> _download() async {
    final item = widget.item;
    final downloadService = DownloadService();
    final galleryService = GalleryService();
    final settings = ref.read(appSettingsProvider);

    final result = await downloadService.download(
      item,
      onProgress: (progress) {
        ref.read(activeDownloadsProvider.notifier).setProgress(item.url, progress);
      },
    );

    ref.read(activeDownloadsProvider.notifier).clear(item.url);

    if (!mounted) return;

    await result.when(
      success: (path) async {
        if (settings.saveToGallery && item.type != MediaType.audio) {
          final saveResult = item.type == MediaType.video
              ? await galleryService.saveVideo(path)
              : await galleryService.saveImage(path);
          if (saveResult.isFailure && mounted) {
            _showMessage('Downloaded, but saving to gallery failed.', isError: true);
          }
        }

        await ref.read(downloadHistoryProvider.notifier).add(
              DownloadHistoryEntry(
                id: const Uuid().v4(),
                title: widget.sourceTitle,
                platform: widget.platform,
                mediaType: item.type,
                quality: item.quality,
                format: item.extension,
                fileSizeBytes: item.dataSize ?? 0,
                localFilePath: path,
                downloadedAt: DateTime.now(),
                sourceUrl: widget.sourceUrl,
                thumbnailUrl: widget.thumbnailUrl,
              ),
            );

        ref.read(interstitialAdServiceProvider).registerDownloadCompleted();
        unawaited(_maybePromptForReview());

        if (mounted) _showMessage('Saved "${widget.sourceTitle}".');
      },
      failure: (message, error) async {
        if (mounted) _showMessage(message, isError: true);
      },
    );

    if (mounted) setState(() => _isBusy = false);
  }

  /// After a few successful downloads, prompt once for a store review.
  /// Both Play Core and `SKStoreReviewController` self-throttle how often
  /// the native dialog can actually appear, but this still only *asks* once
  /// per install so it isn't intrusive.
  Future<void> _maybePromptForReview() async {
    final promptRepo = ref.read(reviewPromptRepositoryProvider);
    if (promptRepo.hasRequestedReview) return;

    final totalDownloads = ref.read(downloadHistoryProvider).length;
    if (totalDownloads < 3) return;

    await promptRepo.markRequested();
    await ref.read(reviewServiceProvider).requestReview();
  }

  IconData _icon(MediaType type) {
    return switch (type) {
      MediaType.audio => Icons.music_note_rounded,
      MediaType.image => Icons.image_rounded,
      MediaType.video => Icons.videocam_rounded,
    };
  }

  Color _iconColor(MediaType type) {
    return switch (type) {
      MediaType.audio => AppColors.successGreen,
      MediaType.image => AppColors.facebookBlue,
      MediaType.video => AppColors.primaryPurple,
    };
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.dangerRed : AppColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final progress = ref.watch(activeDownloadProgressProvider(item.url));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconColor(item.type).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon(item.type), color: _iconColor(item.type)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.displayLabel,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.colors.onSurface,
                        ),
                      ),
                    ),
                    if (item.isHd) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.lock_rounded, size: 14, color: context.colors.onSurfaceVariant),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.fileSize(item.dataSize),
                  style: TextStyle(fontSize: 12, color: context.colors.onSurfaceVariant),
                ),
                if (progress != null) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: context.dividerColor,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primaryPurple),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: ElevatedButton(
              onPressed: _isBusy ? null : _onSavePressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: _isBusy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
