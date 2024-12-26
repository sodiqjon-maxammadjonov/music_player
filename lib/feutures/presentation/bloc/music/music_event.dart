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

class SeekToEvent extends MusicEvent {
  final Duration position;
  SeekToEvent(this.position);
}

class UpdateProgressEvent extends MusicEvent {
  final Duration position;
  UpdateProgressEvent(this.position);
}

class ToggleShuffleEvent extends MusicEvent {}

class ToggleRepeatEvent extends MusicEvent {}

class SetVolumeEvent extends MusicEvent {
  final double volume;
  SetVolumeEvent(this.volume);
}

class AddToPlaylistEvent extends MusicEvent {
  final String songId;
  AddToPlaylistEvent(this.songId);
}

class ShareSongEvent extends MusicEvent {
  final String path;
  ShareSongEvent(this.path);
}
