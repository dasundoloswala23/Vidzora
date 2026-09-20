import 'package:dio/dio.dart';
import '../../core/utils/result.dart';
import '../../models/social_media_response.dart';
import '../config/remote_api_config_service.dart';
import 'api_service.dart';

/// A real, network-backed [ApiService] implementation.
///
/// The endpoint + API key are fetched from Firestore (`app_config/api`,
/// separate `android_*`/`ios_*` fields) via [RemoteApiConfigService], so
/// they can be rotated without a new app release. It calls a RapidAPI-style
/// "autolink" endpoint: `GET <baseUrl>?url=<encoded source url>` with
/// `X-RapidAPI-Key`/`X-RapidAPI-Host` headers, and expects a response shaped
/// like: `{ source, id, unique_id, author, title, thumbnail, duration,
/// statistics, medias: [{ url, quality, extension, type, width, height,
/// data_size }], error }`.
class RealApiService implements ApiService {
  RealApiService({Dio? dio, RemoteApiConfigService? configService})
      : _dio = dio ?? Dio(),
        _configService = configService ?? RemoteApiConfigService();

  final Dio _dio;
  final RemoteApiConfigService _configService;

  @override
  Future<Result<SocialMediaResponse>> fetchMediaInfo(String url) async {
    final config = await _configService.getConfig();
    if (!config.isConfigured) {
      return const Result.failure(
        'The download service isn\'t configured yet. Please try again later.',
      );
    }

    try {
      final host = Uri.parse(config.baseUrl).host;
      final response = await _dio.get<Map<String, dynamic>>(
        config.baseUrl,
        queryParameters: {'url': url},
        options: Options(
          headers: {
            'X-RapidAPI-Key': config.apiKey,
            'X-RapidAPI-Host': host,
          },
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final data = response.data;
      if (data == null) {
        return const Result.failure('Empty response from server.');
      }
      if (data['error'] == true) {
        return Result.failure(
          data['message'] as String? ?? 'This link couldn\'t be processed.',
        );
      }

      final parsed = SocialMediaResponse.fromJson(data);
      if (parsed.medias.isEmpty) {
        return const Result.failure('No downloadable media found for this link.');
      }
      return Result.success(parsed);
    } on DioException catch (e) {
      return Result.failure(
        e.response?.statusCode == 429
            ? 'Too many requests right now. Please try again shortly.'
            : (e.message ?? 'Network error while fetching media info.'),
        e,
      );
    } catch (e) {
      return Result.failure('Unexpected error while fetching media info.', e);
    }
  }
}
