/// Configuration for the backend media-info API.
///
/// The real base URL/key are normally fetched at runtime from the
/// `app_config/api` Firestore document (see [RemoteApiConfigService]) so
/// they can be rotated without shipping a new app build. These constants
/// are only a last-resort fallback if that document is unreachable or
/// unset.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = '';

  static const String apiKey = '';

  static const bool useMockApi = false;
}
