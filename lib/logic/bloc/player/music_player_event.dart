part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent extends Equatable {}

class MusicPlayerInitializeEvent extends MusicPlayerEvent {
  MusicPlayerInitializeEvent(
      {required this.url,
      required this.isOnlineMusic,
      required this.musicAlbum,
      required this.musicTitle,
      required this.onlineMusicThumbnail,
      required this.musicId,
      required this.offlineMusicThumbnail,
      this.artist
      });
  final String url;
  final String musicTitle;
  final String musicAlbum;
  final bool isOnlineMusic;
  final int musicId;
  final String? onlineMusicThumbnail;
  final Uint8List? offlineMusicThumbnail;
  final String? artist;

  @override
  List<Object?> get props => [url];
}

class MusicPlayerTogglePlayPauseEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerStopEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerForwardEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerBackwardEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerRepeatEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerShuffleEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class MusicPlayerSeekEvent extends MusicPlayerEvent {
  MusicPlayerSeekEvent({required this.position});

  final position;
  @override
  List<Object?> get props => [position];
}

class MusicPlayerVolumeSetEvent extends MusicPlayerEvent {
  MusicPlayerVolumeSetEvent({this.volumeLevel});

  final volumeLevel;
  @override
  List<Object?> get props => [volumeLevel];
}

class MusicPlayerDisposeEvent extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}
