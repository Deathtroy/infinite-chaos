import 'package:flutter/material.dart';

class MixScreen extends StatelessWidget {
  const MixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Mix Console',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Number of tracks in the mix
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.music_note),
                            const SizedBox(width: 8),
                            Text('Track ${index + 1}'),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Remove track functionality
                              },
                            ),
                          ],
                        ),
                        Slider(
                          value: 0.5,
                          onChanged: (value) {
                            // Volume control functionality
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Play mix functionality
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play Mix'),
          ),
        ],
      ),
    );
  }
}