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
      default:
        if (normalized.isEmpty) return type == MediaType.audio ? 'Audio' : 'SD';
        final words = normalized.split(RegExp(r'[_\s]+'));
        return words.map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
    }
  }

  String get displayLabel => '$_friendlyQuality Quality · ${extension.toUpperCase()}';

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url'] as String? ?? '',
      type: (json['type'] as String?) == 'audio' ? MediaType.audio : MediaType.video,
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
      'type': type == MediaType.audio ? 'audio' : 'video',
      'quality': quality,
      'extension': extension,
      'width': width,
      'height': height,
      'dataSize': dataSize,
      'duration': duration,
    };
  }
}
