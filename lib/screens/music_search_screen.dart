import 'package:flutter/material.dart';

class MusicSearchScreen extends StatelessWidget {
  const MusicSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search music...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // This will be replaced with actual data
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text('Track ${index + 1}'),
                  subtitle: const Text('Artist Name'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add to mix functionality will be implemented here
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}