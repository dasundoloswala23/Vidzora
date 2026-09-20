/// The user's preferred default download quality.
enum DownloadQuality {
  hd,
  sd,
  audio;

  static DownloadQuality fromIndex(int index) {
    if (index < 0 || index >= DownloadQuality.values.length) return DownloadQuality.hd;
    return DownloadQuality.values[index];
  }

  String get label {
    switch (this) {
      case DownloadQuality.hd:
        return 'HD';
      case DownloadQuality.sd:
        return 'SD';
      case DownloadQuality.audio:
        return 'Audio';
    }
  }
}
