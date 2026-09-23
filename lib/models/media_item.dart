import 'enums/media_type.dart';

/// A single downloadable media variant (a specific quality/format) returned
/// for a fetched social media URL.
class MediaItem {
  const MediaItem({
    required this.url,
    required this.type,
    required this.quality,
    required this.extension,
    this.width,
    this.height,
    this.dataSize,
    this.duration,
  });

  final String url;
  final MediaType type;
  final String quality;
  final String extension;
  final int? width;
  final int? height;
  final int? dataSize;
  final int? duration;

  /// Builds a synthetic downloadable item for a post's thumbnail image.
  /// The thumbnail isn't part of the API's `medias` list, so this is
  /// constructed client-side wherever a "Save Thumbnail" action is offered.
  factory MediaItem.thumbnail(String url) {
    final path = Uri.tryParse(url)?.path ?? '';
    final dotIndex = path.lastIndexOf('.');
    final ext = dotIndex == -1 ? 'jpg' : path.substring(dotIndex + 1).toLowerCase();
    final validExt = RegExp(r'^[a-z0-9]{2,4}$').hasMatch(ext) ? ext : 'jpg';
    return MediaItem(url: url, type: MediaType.image, quality: 'thumbnail', extension: validExt);
  }

  bool get isHd => type == MediaType.video && quality.toUpperCase().contains('HD');

  /// A short, human-friendly quality label. The real download API returns
  /// technical/inconsistent strings across platforms (e.g. `hd_no_watermark`,
  /// `no_watermark`, `watermark`, `Audio`), so this normalizes the common
  /// ones and falls back to title-casing whatever else comes through.
  String get _friendlyQuality {
    final normalized = quality.toLowerCase().trim();
    switch (normalized) {
      case 'hd_no_watermark':
      case 'hd':
        return 'HD';
      case 'no_watermark':
      case 'sd':
        return 'SD';
      case 'watermark':
        return 'Watermarked';
      case 'audio':
        return 'Audio';
      case 'image':
        return 'Image';
      default:
        if (normalized.isEmpty) {
          if (type == MediaType.audio) return 'Audio';
          if (type == MediaType.image) return 'Image';
          return 'SD';
        }
        final words = normalized.split(RegExp(r'[_\s]+'));
        return words.map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
    }
  }

  String get displayLabel => '$_friendlyQuality Quality · ${extension.toUpperCase()}';

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url'] as String? ?? '',
      type: switch (json['type'] as String?) {
        'audio' => MediaType.audio,
        'image' => MediaType.image,
        _ => MediaType.video,
      },
      quality: json['quality'] as String? ?? 'SD',
      extension: json['extension'] as String? ?? 'mp4',
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      // The real API returns `data_size` (snake_case); mock/local data uses
      // `dataSize`. Accept either.
      dataSize: (json['data_size'] as num?)?.toInt() ?? (json['dataSize'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': switch (type) {
        MediaType.audio => 'audio',
        MediaType.image => 'image',
        MediaType.video => 'video',
      },
      'quality': quality,
      'extension': extension,
      'width': width,
      'height': height,
      'dataSize': dataSize,
      'duration': duration,
    };
  }
}
