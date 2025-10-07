class MusicTrack {
  final String id;
  final String title;
  final String category;
  final String fileName;
  final String duration;

  const MusicTrack({
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