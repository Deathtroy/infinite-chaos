import 'media_kit_stub.dart' if (dart.library.io) 'media_kit_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/music_search_screen.dart';
import 'screens/mix_screen.dart';
import 'screens/sound_effects_screen.dart';
import 'widgets/player_widget.dart';
import 'providers/player_provider.dart';

void main() {
  initMediaKit();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Mixer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MusicSearchScreen(),
    const MixScreen(),
    const SoundEffectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Mixer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _screens[_selectedIndex],
          ),
          Consumer<PlayerProvider>(
            builder: (context, playerProvider, child) {
              if (playerProvider.currentTrack == null) return const SizedBox.shrink();
              return PlayerWidget(
                currentTrack: playerProvider.currentTrack,
                onStop: playerProvider.stopPlayback,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: 'Mix',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Effects',
          ),
        ],
      ),
    );
  }
}
