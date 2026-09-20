import 'media_item.dart';

/// The parsed response from fetching a social media URL's info.
class SocialMediaResponse {
  const SocialMediaResponse({
    required this.source,
    required this.id,
    required this.author,
    required this.uniqueId,
    required this.title,
    required this.thumbnail,
    this.duration,
    this.statistics,
    required this.medias,
  });

  final String source;
  final String id;
  final String author;
  final String uniqueId;
  final String title;
  final String thumbnail;
  final int? duration;
  final Map<String, dynamic>? statistics;
  final List<MediaItem> medias;

  factory SocialMediaResponse.fromJson(Map<String, dynamic> json) {
    return SocialMediaResponse(
      source: json['source'] as String? ?? '',
      id: json['id'] as String? ?? '',
      author: json['author'] as String? ?? '',
      // The real API returns `unique_id` (snake_case); accept either.
      uniqueId: json['unique_id'] as String? ?? json['uniqueId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt(),
      statistics: json['statistics'] as Map<String, dynamic>?,
      medias: (json['medias'] as List<dynamic>? ?? [])
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'id': id,
      'author': author,
      'uniqueId': uniqueId,
      'title': title,
      'thumbnail': thumbnail,
      'duration': duration,
      'statistics': statistics,
      'medias': medias.map((e) => e.toJson()).toList(),
    };
  }
}
