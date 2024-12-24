import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String path;
  final Duration duration;
  final String? artwork;
  final DateTime dateAdded;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.path,
    required this.duration,
    this.artwork,
    required this.dateAdded,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? path,
    Duration? duration,
    String? artwork,
    DateTime? dateAdded,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      artwork: artwork ?? this.artwork,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'path': path,
      'duration': duration.inMilliseconds,
      'artwork': artwork,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      path: map['path'],
      duration: Duration(milliseconds: map['duration']),
      artwork: map['artwork'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }

  @override
  List<Object?> get props => [id, title, artist, album, path, duration, artwork, dateAdded];
}