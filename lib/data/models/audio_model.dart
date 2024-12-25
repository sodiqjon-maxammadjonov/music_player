class AudioModel {
  final int id;
  final String title;
  final String? artist;
  final int duration;
  final String path;
  final String folderPath;
  bool isFavorite;

  AudioModel({
    required this.id,
    required this.title,
    this.artist,
    required this.duration,
    required this.path,
    required this.folderPath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'path': path,
      'folder_path': folderPath,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      duration: map['duration'],
      path: map['path'],
      folderPath: map['folder_path'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}