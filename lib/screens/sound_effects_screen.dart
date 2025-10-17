import 'package:flutter/material.dart';
import '../models/music_track.dart';
import '../services/effect_service.dart';

class SoundEffectsScreen extends StatefulWidget {
  const SoundEffectsScreen({super.key});

  @override
  State<SoundEffectsScreen> createState() => _SoundEffectsScreenState();
}

class _SoundEffectsScreenState extends State<SoundEffectsScreen> {
  final EffectService _effectService = EffectService();
  List<MusicTrack> _effects = [];

  @override
  void initState() {
    super.initState();
    _loadEffects();
    _effectService.addListener(_onEffectStateChanged);
  }

  @override
  void dispose() {
    _effectService.removeListener(_onEffectStateChanged);
    super.dispose();
  }

  void _onEffectStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _loadEffects() {
    setState(() {
      _effects = _effectService.getAllEffects();
    });
  }

  Future<void> _removeEffect(String trackId) async {
    // If the effect is currently playing, stop it first
    if (_effectService.playingEffectId == trackId) {
      await _effectService.stopEffect();
    }
    await _effectService.removeEffect(trackId);
    _loadEffects();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Effect removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_effects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No sound effects added yet',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Go to the Search screen and look for FX tracks to add them here',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Search Effects'),
              onPressed: () {
                // Navigate to the search screen with FX filter
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: _effects.length,
        itemBuilder: (context, index) {
          final track = _effects[index];
          return Card(
            child: InkWell(
              onLongPress: () => _removeEffect(track.id),
              onTap: () => _effectService.playEffect(track),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _effectService.isPlaying && _effectService.playingEffectId == track.id
                            ? Icons.stop_circle
                            : Icons.play_circle,
                        size: 28,
                        color: _effectService.playingEffectId == track.id
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.title,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}