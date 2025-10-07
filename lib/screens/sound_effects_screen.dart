import 'package:flutter/material.dart';

class SoundEffectsScreen extends StatelessWidget {
  const SoundEffectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 8, // Number of sound effects
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                // Play sound effect functionality
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text('Effect ${index + 1}'),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      // Add to mix functionality
                    },
                    child: const Text('Add to Mix'),
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