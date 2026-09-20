import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_config.dart';
import '../core/utils/result.dart';
import '../models/social_media_response.dart';
import '../services/api/api_service.dart';
import '../services/api/mock_api_service.dart';
import '../services/api/real_api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiConfig.useMockApi ? MockApiService() : RealApiService();
});

/// Handles submitting a URL and holding the fetch result state.
class MediaFetchController extends AsyncNotifier<SocialMediaResponse?> {
  @override
  Future<SocialMediaResponse?> build() async {
    return null;
  }

  Future<void> fetch(String url) async {
    state = const AsyncLoading();
    final api = ref.read(apiServiceProvider);
    final result = await api.fetchMediaInfo(url);
    state = result.when(
      success: (data) => AsyncData(data),
      failure: (message, error) => AsyncError(message, StackTrace.current),
    );
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final mediaFetchControllerProvider =
    AsyncNotifierProvider<MediaFetchController, SocialMediaResponse?>(
  MediaFetchController.new,
);

typedef FetchResult = Result<SocialMediaResponse>;
