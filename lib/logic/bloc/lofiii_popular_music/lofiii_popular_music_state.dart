part of 'lofiii_popular_music_bloc.dart';

@immutable
abstract class LofiiiPopularMusicState extends Equatable {}


class LofiiiPopularMusicInitial extends LofiiiPopularMusicState {
  @override
  List<Object?> get props => [];
}


class LofiiiPopularMusicLoadingState extends LofiiiPopularMusicState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LofiiiPopularMusicSuccessState extends LofiiiPopularMusicState{


  final List<MusicModel> musicList;

  LofiiiPopularMusicSuccessState({required this.musicList});

  @override
  // TODO: implement props
  List<Object?> get props => [musicList];
}


class LofiiiPopularMusicFailureState extends LofiiiPopularMusicState {


  final String errorMessage;

  LofiiiPopularMusicFailureState({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
