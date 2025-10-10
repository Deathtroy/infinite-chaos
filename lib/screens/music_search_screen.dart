import 'package:flutter/material.dart';
import '../models/music_track.dart';
import '../repositories/music_repository.dart';
import '../widgets/player_widget.dart';

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
  MusicTrack? _selectedTrack;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final tracks = await _repository.loadTracks();
    setState(() {
      _tracks = tracks;
      _filteredTracks = tracks;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _filteredTracks = List.from(_tracks);
      } else {
        _filteredTracks = _tracks.where((track) {
          final title = track.title.toLowerCase();
          final category = track.category.toLowerCase();
          final searchLower = _searchQuery.toLowerCase();
          return title.contains(searchLower) || category.contains(searchLower);
        }).toList();
      }
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
              TextField(
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
              const SizedBox(height: 16),
              Expanded(
                child: _tracks.isEmpty
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
                            padding: EdgeInsets.only(
                              bottom: _selectedTrack != null ? 100 : 16
                            ),
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
                                    leading: Icon(
                                      isSelected ? Icons.music_note : Icons.music_note_outlined,
                                      color: isSelected 
                                          ? Theme.of(context).colorScheme.primary
                                          : null,
                                    ),
                                    title: Text(
                                      track.title,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : null,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${track.category} • ${track.duration}',
                                      style: TextStyle(
                                        color: isSelected 
                                            ? Theme.of(context).colorScheme.primary
                                            : null,
                                      ),
                                    ),
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
            left: 0,
            right: 0,
            bottom: 0,
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