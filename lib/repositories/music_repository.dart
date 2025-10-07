import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/music_track.dart';

class MusicRepository {
  static const String _tracksPath = 'assets/audio/tracks.json';
  List<MusicTrack> _tracks = [];

  Future<List<MusicTrack>> loadTracks() async {
    if (_tracks.isNotEmpty) {
      return _tracks;
    }

    final String jsonString = await rootBundle.loadString(_tracksPath);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> tracksList = jsonData['tracks'];
    
    _tracks = tracksList.map((json) => MusicTrack.fromJson(json)).toList();
    return _tracks;
  }

  List<MusicTrack> searchTracks(String query) {
    if (query.isEmpty) {
      return _tracks;
    }

    final lowercaseQuery = query.toLowerCase();
    return _tracks.where((track) {
      return track.title.toLowerCase().contains(lowercaseQuery) ||
          track.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}