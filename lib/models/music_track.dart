import 'package:hive/hive.dart';

part 'music_track.g.dart';

@HiveType(typeId: 2)
class MusicTrack {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final String fileName;
  
  @HiveField(4)
  final String duration;

  MusicTrack({
    required this.id,
    required this.title,
    required this.category,
    required this.fileName,
    required this.duration,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      fileName: json['fileName'] as String,
      duration: json['duration'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'fileName': fileName,
        'duration': duration,
      };
}