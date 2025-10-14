import 'package:hive/hive.dart';
import 'music_track.dart';

part 'mix.g.dart';

@HiveType(typeId: 0)
class TrackVolume {
  @HiveField(0)
  final MusicTrack track;

  @HiveField(1)
  double volume;

  TrackVolume({
    required this.track,
    this.volume = 1.0,
  });
}

@HiveType(typeId: 1)
class Mix {
  @HiveField(0)
  List<TrackVolume> tracks;

  Mix({
    List<TrackVolume>? tracks,
  }) : tracks = tracks ?? [];

  bool get isFull => tracks.length >= 4;
}