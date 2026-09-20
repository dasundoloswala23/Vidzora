import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/result.dart';
import '../../models/media_item.dart';

/// Downloads a [MediaItem]'s file to local temporary storage.
class DownloadService {
  DownloadService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Result<String>> download(
    MediaItem item, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName =
          'vidzora_${DateTime.now().millisecondsSinceEpoch}.${item.extension}';
      final path = '${dir.path}${Platform.pathSeparator}$fileName';

      await _dio.download(
        item.url,
        path,
        // Some CDNs (TikTok/Facebook media hosts) reject requests without a
        // browser-like User-Agent.
        options: Options(
          headers: const {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
          },
          receiveTimeout: const Duration(minutes: 2),
        ),
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return Result.success(path);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Download failed.', e);
    } catch (e) {
      return Result.failure('Unexpected error while downloading.', e);
    }
  }
}
