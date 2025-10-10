import 'package:flutter/foundation.dart';
import '../models/music_track.dart';

class PlayerProvider extends ChangeNotifier {
  MusicTrack? _currentTrack;
  MusicTrack? get currentTrack => _currentTrack;

  void playTrack(MusicTrack track) {
    _currentTrack = track;
    notifyListeners();
  }

  void stopPlayback() {
    _currentTrack = null;
    notifyListeners();
  }
}