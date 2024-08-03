part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerState extends Equatable{}




class MusicPlayerLoadingState extends MusicPlayerState {
  @override
  List<Object?> get props => [];
}

class MusicPlayerSuccessState extends MusicPlayerState {

  final AudioPlayer audioPlayer;

  final Stream<Duration> positionStream;
  final Stream<Duration?> durationStream;
  final Stream<bool> playingStream;
  final Stream<List<Duration?>> combinedStreamPositionAndDurationAndBufferedList;


  MusicPlayerSuccessState({required this.positionStream,required this.durationStream,required this.playingStream, required this.audioPlayer, required this.combinedStreamPositionAndDurationAndBufferedList});

  @override
  // TODO: implement props
  List<Object?> get props => [audioPlayer, positionStream, durationStream, playingStream, combinedStreamPositionAndDurationAndBufferedList];
}

class MusicPlayerErrorState extends MusicPlayerState{
  MusicPlayerErrorState({required this.errorMessage});

  final String errorMessage;
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

