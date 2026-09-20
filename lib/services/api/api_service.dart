import '../../core/utils/result.dart';
import '../../models/social_media_response.dart';

/// Abstract contract for fetching media info from a social media URL.
abstract class ApiService {
  Future<Result<SocialMediaResponse>> fetchMediaInfo(String url);
}
