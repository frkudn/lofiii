
part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent extends Equatable{}


class MusicPlayerInitializeEvent extends MusicPlayerEvent{
  MusicPlayerInitializeEvent({required this.url});
  final String url;

  @override
  // TODO: implement props
  List<Object?> get props => [url];
}


class MusicPlayerTogglePlayPauseEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerStopEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerForwardEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerBackwardEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class MusicPlayerRepeatEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerShuffleEvent extends MusicPlayerEvent{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerSeekEvent extends MusicPlayerEvent{
  MusicPlayerSeekEvent({required this.position});

  final  position;
  @override
  // TODO: implement props
  List<Object?> get props => [position];
}

class MusicPlayerVolumeSetEvent extends MusicPlayerEvent{
  MusicPlayerVolumeSetEvent({this.volumeLevel});

  final volumeLevel;
  @override
  // TODO: implement props
  List<Object?> get props => [volumeLevel];
}





