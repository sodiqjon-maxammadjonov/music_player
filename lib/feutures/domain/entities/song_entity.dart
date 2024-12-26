class SongEntity {
  final String id;
  final String title;
  final String artist;
  final String path;
  final bool isFavorite;
  final Duration duration;

  const SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
    this.isFavorite = false,
    required this.duration,
  });
}
