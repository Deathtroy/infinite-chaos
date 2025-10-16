import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/mix.dart';

class MixService extends ChangeNotifier {
  static final MixService _instance = MixService._internal();
  factory MixService() => _instance;
  MixService._internal();

  final Map<String, AudioPlayer> _players = {};
  bool _isPlaying = false;
  Mix? _currentMix;

  bool get isPlaying => _isPlaying;
  Mix? get currentMix => _currentMix;

  Future<void> initializeMix(Mix mix) async {
    _currentMix = mix;
    // Dispose old players if they exist
    await disposePlayers();
    
    // Initialize new players
    for (var track in mix.tracks) {
      final player = AudioPlayer();
      await player.setAsset('assets/audio/${track.track.fileName}');
      await player.setVolume(track.volume);
      _players[track.track.id] = player;
    }
  }

  Future<void> updateVolume(String trackId, double volume) async {
    await _players[trackId]?.setVolume(volume);
  }

  Future<void> togglePlayback() async {
    _isPlaying = !_isPlaying;
    notifyListeners();  // Notify listeners of state change

    if (!_isPlaying) {
      await Future.wait(
        _players.values.map((player) => player.stop()),
      );
    } else {
      await Future.wait(
        _players.values.map((player) => player.seek(Duration.zero)),
      );
      await Future.wait(
        _players.values.map((player) => player.play()),
      );
    }
  }

  Future<void> removeTrack(String trackId) async {
    await _players[trackId]?.dispose();
    _players.remove(trackId);
  }

  Future<void> disposePlayers() async {
    for (var player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _isPlaying = false;
  }
}