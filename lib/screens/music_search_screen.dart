import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/music_track.dart';
import '../models/mix.dart';
import '../repositories/music_repository.dart';
import '../providers/player_provider.dart';

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
    return Padding(
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
                    : Consumer<PlayerProvider>(
                        builder: (context, playerProvider, child) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _filteredTracks.length,
                            itemBuilder: (context, index) {
                              final track = _filteredTracks[index];
                              final isSelected = playerProvider.currentTrack?.id == track.id;
                
                              return Card(
                                elevation: isSelected ? 4 : 1,
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                                child: InkWell(
                                  onTap: () => playerProvider.playTrack(track),
                                  child: ListTile(
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add),
                                      tooltip: 'Add to mix',
                                      onPressed: () async {
                                        final box = await Hive.openBox<Mix>('mix');
                                        final mix = box.get('current') ?? Mix();
                                        
                                        if (!mix.isFull) {
                                          mix.tracks.add(TrackVolume(track: track));
                                          await box.put('current', mix);
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Added "${track.title}" to mix'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Mix is full (maximum 4 tracks)'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                    ),
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}