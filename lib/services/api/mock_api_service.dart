import '../../core/utils/result.dart';
import '../../core/utils/url_validator.dart';
import '../../models/enums/media_type.dart';
import '../../models/media_item.dart';
import '../../models/social_media_response.dart';
import 'api_service.dart';

/// A mock [ApiService] implementation that fabricates a plausible response
/// for any valid URL, without making any network calls. This is what the
/// app actually uses by default (see [ApiConfig.useMockApi]).
class MockApiService implements ApiService {
  @override
  Future<Result<SocialMediaResponse>> fetchMediaInfo(String url) async {
    if (!UrlValidator.isValidUrl(url)) {
      return const Result.failure('Please enter a valid URL.');
    }

    await Future.delayed(const Duration(milliseconds: 1200));

    final platform = UrlValidator.detectPlatform(url);

    final response = SocialMediaResponse(
      source: platform,
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      author: 'Sample Creator',
      uniqueId: '@sample.creator',
      title: 'Sample video from $platform',
      thumbnail: 'https://picsum.photos/seed/$platform/400/300',
      duration: 32,
      statistics: const {'likeCount': 1204, 'shareCount': 88, 'commentCount': 41},
      medias: [
        const MediaItem(
          url: 'https://example.com/mock/video-hd.mp4',
          type: MediaType.video,
          quality: 'HD',
          extension: 'mp4',
          width: 1280,
          height: 720,
          dataSize: 14 * 1024 * 1024,
          duration: 32,
        ),
        const MediaItem(
          url: 'https://example.com/mock/video-sd.mp4',
          type: MediaType.video,
          quality: 'SD',
          extension: 'mp4',
          width: 640,
          height: 480,
          dataSize: 5 * 1024 * 1024,
          duration: 32,
        ),
        const MediaItem(
          url: 'https://example.com/mock/audio.mp3',
          type: MediaType.audio,
          quality: 'Audio',
          extension: 'mp3',
          dataSize: 3 * 1024 * 1024,
          duration: 32,
        ),
      ],
    );

    return Result.success(response);
  }
}
