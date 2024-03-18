part of 'lofiii_special_music_bloc.dart';

@immutable
abstract class LofiiiSpecialMusicState extends Equatable {}

class LofiiiSpecialMusicInitial extends LofiiiSpecialMusicState {
  @override
  List<Object?> get props => [];
}


class LofiiiSpecialMusicLoadingState extends LofiiiSpecialMusicState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LofiiiSpecialMusicSuccessState extends LofiiiSpecialMusicState{


  final List<MusicModel> musicList;

  LofiiiSpecialMusicSuccessState({required this.musicList});

  @override
  // TODO: implement props
  List<Object?> get props => [musicList];
}


class LofiiiSpecialMusicFailureState extends LofiiiSpecialMusicState{


  final String errorMessage;

  LofiiiSpecialMusicFailureState({required this.errorMessage});
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
