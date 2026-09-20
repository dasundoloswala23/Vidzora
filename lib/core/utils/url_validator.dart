/// URL validation and social-platform detection helpers.
class UrlValidator {
  UrlValidator._();

  static bool isValidUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return false;
    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Detects a supported platform id from a URL's host, defaulting to
  /// 'tiktok' when nothing matches (used for mock data generation).
  static String detectPlatform(String url) {
    final host = Uri.tryParse(url.trim())?.host.toLowerCase() ?? '';
    if (host.contains('tiktok')) return 'tiktok';
    if (host.contains('instagram')) return 'instagram';
    if (host.contains('facebook') || host.contains('fb.watch')) return 'facebook';
    if (host.contains('linkedin')) return 'linkedin';
    return 'tiktok';
  }
}
