
class Song {
  final int id;
  final String title;
  final String? artist;
  final String? album;
  final int? duration;
  final String path;
  final String? artworkPath;
  final DateTime createdAt;

  Song({
    required this.id,
    required this.title,
    this.artist,
    this.album,
    this.duration,
    required this.path,
    this.artworkPath,
    required this.createdAt,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String?,
      album: map['album'] as String?,
      duration: map['duration'] as int?,
      path: map['path'] as String,
      artworkPath: map['artwork_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'path': path,
      'artwork_path': artworkPath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    int? duration,
    String? path,
    String? artworkPath,
    DateTime? createdAt,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      path: path ?? this.path,
      artworkPath: artworkPath ?? this.artworkPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}