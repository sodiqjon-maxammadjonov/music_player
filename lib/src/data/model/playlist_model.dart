import 'music_model.dart';

class Playlist {
  final int? id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Song> songs;

  Playlist({
    this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.songs = const [],
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      songs: (map['songs'] as List?)?.map((songMap) => Song.fromMap(songMap as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'songs': songs.map((song) => song.toMap()).toList(),
    };
  }
}
