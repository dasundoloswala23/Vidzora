import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'enums/download_quality.dart';

/// Persisted user preferences, stored as a single Hive record.
class AppSettings {
  const AppSettings({
    this.downloadQuality = DownloadQuality.hd,
    this.autoSave = false,
    this.wifiOnly = true,
    this.saveToGallery = true,
    this.themeMode = ThemeMode.system,
  });

  final DownloadQuality downloadQuality;
  final bool autoSave;
  final bool wifiOnly;
  final bool saveToGallery;
  final ThemeMode themeMode;

  AppSettings copyWith({
    DownloadQuality? downloadQuality,
    bool? autoSave,
    bool? wifiOnly,
    bool? saveToGallery,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      downloadQuality: downloadQuality ?? this.downloadQuality,
      autoSave: autoSave ?? this.autoSave,
      wifiOnly: wifiOnly ?? this.wifiOnly,
      saveToGallery: saveToGallery ?? this.saveToGallery,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Hand-written Hive [TypeAdapter] for [AppSettings].
///
/// Field order/index map:
/// 0 downloadQuality (index), 1 autoSave, 2 wifiOnly, 3 saveToGallery, 4 themeMode (index)
class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      downloadQuality: DownloadQuality.fromIndex(fields[0] as int),
      autoSave: fields[1] as bool,
      wifiOnly: fields[2] as bool,
      saveToGallery: fields[3] as bool,
      themeMode: ThemeMode.values[fields[4] as int],
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.downloadQuality.index)
      ..writeByte(1)
      ..write(obj.autoSave)
      ..writeByte(2)
      ..write(obj.wifiOnly)
      ..writeByte(3)
      ..write(obj.saveToGallery)
      ..writeByte(4)
      ..write(obj.themeMode.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
