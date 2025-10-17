import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/music_track.dart';
import '../models/mix.dart';
import '../repositories/music_repository.dart';
import '../widgets/player_widget.dart';
import '../widgets/add_track_button.dart';

class MusicSearchScreen extends StatefulWidget {
  const MusicSearchScreen({super.key});

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  final MusicRepository _repository = MusicRepository();
  List<MusicTrack> _tracks = [];
  List<MusicTrack> _filteredTracks = [];
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isBoxReady = false;
  MusicTrack? _selectedTrack;

  @override
  void initState() {
    super.initState();
    _initBox();
    _loadTracks();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen('mix')) {
      await Hive.openBox<Mix>('mix');
    }
    if (mounted) {
      setState(() {
        _isBoxReady = true;
      });
    }
  }

  Future<void> _loadTracks() async {
    final tracks = await _repository.loadTracks();
    setState(() {
      _tracks = tracks;
      _filteredTracks = tracks;
    });
  }

  void _filterTracks() {
    setState(() {
      _filteredTracks = _tracks.where((track) {
        final title = track.title.toLowerCase();
        final category = track.category.toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch = _searchQuery.isEmpty || 
          title.contains(searchLower) || 
          category.contains(searchLower);
        final matchesCategory = _selectedCategory == null || 
          track.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      _filterTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search music...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _filteredTracks = List.from(_tracks);
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text('All'),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All'),
                      ),
                      ...{'fx', 'ambience'}.map((category) => 
                        DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      ),
                    ],
                    onChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                        _filterTracks();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
          Expanded(
            child: !_isBoxReady || _tracks.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredTracks.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'No tracks available'
                              : 'No tracks matching "$_searchQuery"',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _filteredTracks.length,
                            itemBuilder: (context, index) {
                              final track = _filteredTracks[index];
                              final isSelected = _selectedTrack?.id == track.id;
                
                              return Card(
                                elevation: isSelected ? 4 : 1,
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedTrack = track;
                                    });
                                  },
                                  child: ListTile(
                                    trailing: AddTrackButton(
                                      track: track,
                                    ),
                                    leading: Icon(
                                      isSelected ? Icons.music_note : Icons.music_note_outlined,
                                      color: isSelected 
                                          ? Theme.of(context).colorScheme.primary
                                          : null,
                                    ),
                                    title: Text(track.title),
                                    subtitle: Text(track.category),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
            ],
          ),
        ),
        if (_selectedTrack != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: PlayerWidget(
              currentTrack: _selectedTrack,
              onStop: () {
                setState(() => _selectedTrack = null);
              },
            ),
          ),
      ],
    );
  }
}