// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mix.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackVolumeAdapter extends TypeAdapter<TrackVolume> {
  @override
  final int typeId = 0;

  @override
  TrackVolume read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackVolume(
      track: fields[0] as MusicTrack,
      volume: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TrackVolume obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.track)
      ..writeByte(1)
      ..write(obj.volume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackVolumeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MixAdapter extends TypeAdapter<Mix> {
  @override
  final int typeId = 1;

  @override
  Mix read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mix(
      tracks: (fields[0] as List?)?.cast<TrackVolume>(),
    );
  }

  @override
  void write(BinaryWriter writer, Mix obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
