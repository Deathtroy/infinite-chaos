import 'media_kit_stub.dart' if (dart.library.io) 'media_kit_impl.dart';
import 'package:flutter/material.dart';
import 'screens/music_search_screen.dart';
import 'screens/mix_screen.dart';
import 'screens/sound_effects_screen.dart';

void main() {
  initMediaKit();
  runApp(const MainApp());
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
      body: _screens[_selectedIndex],
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
