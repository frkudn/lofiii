part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerState extends Equatable{}




class MusicPlayerLoadingState extends MusicPlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicPlayerSuccessState extends MusicPlayerState {

  final AudioPlayer audioPlayer;

  final Stream<Duration> positionStream;
  final Stream<Duration?> durationStream;
  final Stream<bool> playingStream;


  MusicPlayerSuccessState({required this.positionStream,required this.durationStream,required this.playingStream, required this.audioPlayer});

  @override
  // TODO: implement props
  List<Object?> get props => [audioPlayer, positionStream, durationStream, playingStream];
}

class MusicPlayerErrorState extends MusicPlayerState{
  MusicPlayerErrorState({required this.errorMessage});

  final String errorMessage;
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

