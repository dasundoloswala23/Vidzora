import 'package:hive/hive.dart';
import 'enums/media_type.dart';

/// A completed download record persisted in Hive.
class DownloadHistoryEntry {
  DownloadHistoryEntry({
    required this.id,
    required this.title,
    required this.platform,
    required this.mediaType,
    required this.quality,
    required this.format,
    required this.fileSizeBytes,
    required this.localFilePath,
    required this.downloadedAt,
    this.sourceUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String platform;
  final MediaType mediaType;
  final String quality;
  final String format;
  final int fileSizeBytes;
  final String localFilePath;
  final DateTime downloadedAt;
  final String? sourceUrl;
  final String? thumbnailUrl;
}

/// Hand-written Hive [TypeAdapter] for [DownloadHistoryEntry].
///
/// Field order/index map:
/// 0 id, 1 title, 2 platform, 3 mediaType (index), 4 quality, 5 format,
/// 6 fileSizeBytes, 7 localFilePath, 8 downloadedAt (millisSinceEpoch), 9 sourceUrl,
/// 10 thumbnailUrl
class DownloadHistoryEntryAdapter extends TypeAdapter<DownloadHistoryEntry> {
  @override
  final int typeId = 0;

  @override
  DownloadHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadHistoryEntry(
      id: fields[0] as String,
      title: fields[1] as String,
      platform: fields[2] as String,
      mediaType: MediaType.fromIndex(fields[3] as int),
      quality: fields[4] as String,
      format: fields[5] as String,
      fileSizeBytes: fields[6] as int,
      localFilePath: fields[7] as String,
      downloadedAt: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
      sourceUrl: fields[9] as String?,
      // Older records written before this field existed simply won't have
      // key 10 present, so this defaults to null for them.
      thumbnailUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadHistoryEntry obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.platform)
      ..writeByte(3)
      ..write(obj.mediaType.index)
      ..writeByte(4)
      ..write(obj.quality)
      ..writeByte(5)
      ..write(obj.format)
      ..writeByte(6)
      ..write(obj.fileSizeBytes)
      ..writeByte(7)
      ..write(obj.localFilePath)
      ..writeByte(8)
      ..write(obj.downloadedAt.millisecondsSinceEpoch)
      ..writeByte(9)
      ..write(obj.sourceUrl)
      ..writeByte(10)
      ..write(obj.thumbnailUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadHistoryEntryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
