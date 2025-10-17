import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/music_track.dart';
import '../models/mix.dart';
import '../services/effect_service.dart';

class AddTrackButton extends StatelessWidget {
  final MusicTrack track;

  const AddTrackButton({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    // For FX category
    if (track.category == 'fx') {
      return IconButton(
        icon: const Icon(Icons.flash_on),
        tooltip: 'Add as effect',
        onPressed: () async {
          await EffectService().addEffect(track);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "${track.title}" to effects'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    }
    
    // For Ambience category
    if (track.category == 'ambience') {
      return ValueListenableBuilder<Box<Mix>>(
        valueListenable: Hive.box<Mix>('mix').listenable(),
        builder: (context, box, child) {
          final mix = box.get('current') ?? Mix();
          final isInMix = mix.tracks.any((t) => t.track.id == track.id);
          
          if (!isInMix) {
            return IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add to mix',
              onPressed: () async {
                if (!mix.isFull) {
                  mix.tracks.add(TrackVolume(track: track));
                  await box.put('current', mix);
                  
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added "${track.title}" to mix'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mix is full (maximum 4 tracks)'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }
          return const SizedBox();
        },
      );
    }
    
    // For any other category
    return const SizedBox();
  }
}