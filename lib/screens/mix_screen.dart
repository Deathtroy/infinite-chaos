import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/mix.dart';

class MixScreen extends StatefulWidget {
  const MixScreen({super.key});

  @override
  State<MixScreen> createState() => _MixScreenState();
}

class _MixScreenState extends State<MixScreen> {
  Mix? _mix;
  final Map<String, AudioPlayer> _players = {};
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadMix();
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> _loadMix() async {
    final box = await Hive.openBox<Mix>('mix');
    final mix = box.get('current');
    setState(() {
      _mix = mix ?? Mix();
    });

    // Initialize players for each track
    for (var track in _mix?.tracks ?? []) {
      final player = AudioPlayer();
      await player.setAsset('assets/audio/${track.track.fileName}');
      await player.setVolume(track.volume);
      _players[track.track.id] = player;
    }
  }

  Future<void> _saveMix() async {
    if (_mix != null) {
      final box = await Hive.openBox<Mix>('mix');
      await box.put('current', _mix!);
    }
  }

  Future<void> _updateVolume(String trackId, double volume) async {
    final trackIndex = _mix?.tracks.indexWhere((t) => t.track.id == trackId) ?? -1;
    if (trackIndex != -1) {
      setState(() {
        _mix!.tracks[trackIndex].volume = volume;
      });
      await _players[trackId]?.setVolume(volume);
      await _saveMix();
    }
  }

  Future<void> _removeTrack(String trackId) async {
    final trackIndex = _mix?.tracks.indexWhere((t) => t.track.id == trackId) ?? -1;
    if (trackIndex != -1) {
      await _players[trackId]?.dispose();
      _players.remove(trackId);
      
      setState(() {
        _mix!.tracks.removeAt(trackIndex);
      });
      await _saveMix();
    }
  }

  Future<void> _togglePlayback() async {
  if (!mounted) return;

  try {
    setState(() {
      // Update state immediately for better UI feedback
      _isPlaying = !_isPlaying;
    });

    if (!_isPlaying) {
      // We're stopping
      await Future.wait(
        _players.values.map((player) => player.stop()),
      );
    } else {
      // We're starting
      // First seek all players to start
      await Future.wait(
        _players.values.map((player) => player.seek(Duration.zero)),
      );
      // Then play all players
      await Future.wait(
        _players.values.map((player) => player.play()),
      );
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _isPlaying = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error playing mix: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Mix Console (${_mix?.tracks.length ?? 0}/4 tracks)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          if (_mix == null)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_mix!.tracks.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Add tracks from the search screen to create a mix'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _mix!.tracks.length,
                itemBuilder: (context, index) {
                  final trackVolume = _mix!.tracks[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.music_note),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trackVolume.track.title,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      trackVolume.track.category,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeTrack(trackVolume.track.id),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.volume_up, size: 20),
                              Expanded(
                                child: Slider(
                                  value: trackVolume.volume,
                                  onChanged: (value) => _updateVolume(trackVolume.track.id, value),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '${(trackVolume.volume * 100).round()}%',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_mix?.tracks.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: _togglePlayback,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? 'Stop' : 'Play Mix'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
        ],
      ),
    );
  }
}