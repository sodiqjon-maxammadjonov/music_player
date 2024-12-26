part of 'music_bloc.dart';

@immutable
sealed class MusicEvent {}
class LoadSongsEvent extends MusicEvent {}
class PlaySongEvent extends MusicEvent {
  final SongEntity song;
  PlaySongEvent(this.song);
}
class TogglePlayPauseEvent extends MusicEvent {}
class NextSongEvent extends MusicEvent {}
class PreviousSongEvent extends MusicEvent {}
class ToggleFavoriteEvent extends MusicEvent {
  final String songId;
  ToggleFavoriteEvent(this.songId);
}
class DeleteSongEvent extends MusicEvent {
  final String songId;
  DeleteSongEvent(this.songId);
}