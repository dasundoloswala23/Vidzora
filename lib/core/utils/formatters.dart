import 'package:intl/intl.dart';

/// Formatting helpers for file sizes and dates used across the UI.
class Formatters {
  Formatters._();

  static String fileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '--';
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    final formatted = size >= 10 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
    return '$formatted ${units[unitIndex]}';
  }

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return DateFormat.yMMMd().format(date);
  }
}
