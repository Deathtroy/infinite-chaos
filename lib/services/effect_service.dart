import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/music_track.dart';

class EffectService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final Box<MusicTrack> _effectsBox;
  String? _playingEffectId;
  bool _isPlaying = false;

  EffectService() : _effectsBox = Hive.box<MusicTrack>('effects');

  bool get isPlaying => _isPlaying;
  String? get playingEffectId => _playingEffectId;

  List<MusicTrack> getAllEffects() {
    return _effectsBox.values.toList();
  }

  Future<void> addEffect(MusicTrack track) async {
    await _effectsBox.put(track.id, track);
    notifyListeners();
  }

  Future<void> removeEffect(String id) async {
    if (_playingEffectId == id) {
      await stopEffect();
    }
    await _effectsBox.delete(id);
    notifyListeners();
  }

  Future<void> playEffect(MusicTrack effect) async {
    if (_playingEffectId == effect.id && _isPlaying) {
      await stopEffect();
      return;
    }

    _playingEffectId = effect.id;
    _isPlaying = true;
    notifyListeners();

    try {
      await _player.setAsset('assets/audio/${effect.fileName}');
      await _player.play();
      
      // Auto-stop when effect completes
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _playingEffectId = null;
          notifyListeners();
        }
      });
    } catch (e) {
      _isPlaying = false;
      _playingEffectId = null;
      notifyListeners();
      debugPrint('Error playing effect: $e');
    }
  }

  Future<void> stopEffect() async {
    await _player.stop();
    _isPlaying = false;
    _playingEffectId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}