/// The kind of media a download or media item represents.
enum MediaType {
  video,
  audio;

  static MediaType fromIndex(int index) {
    if (index < 0 || index >= MediaType.values.length) return MediaType.video;
    return MediaType.values[index];
  }
}
