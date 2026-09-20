import 'package:gal/gal.dart';
import '../../core/utils/result.dart';

/// Wraps the `gal` package to save media files to the device gallery.
class GalleryService {
  Future<Result<void>> saveVideo(String path) async {
    try {
      await Gal.putVideo(path);
      return const Result.success(null);
    } on GalException catch (e) {
      return Result.failure(e.type.message, e);
    } catch (e) {
      return Result.failure('Failed to save video to gallery.', e);
    }
  }

  Future<Result<void>> saveImage(String path) async {
    try {
      await Gal.putImage(path);
      return const Result.success(null);
    } on GalException catch (e) {
      return Result.failure(e.type.message, e);
    } catch (e) {
      return Result.failure('Failed to save image to gallery.', e);
    }
  }
}
