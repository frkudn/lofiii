import 'package:equatable/equatable.dart';

import '../../../data/models/music_model.dart';

abstract class LofiiiAllMusicState extends Equatable {}

class LofiiiAllMusicInitial extends LofiiiAllMusicState {
  @override
  List<Object?> get props => [];
}

class LofiiiAllMusicLoadingState extends LofiiiAllMusicState {
  @override
  List<Object?> get props => [];
}

class LofiiiAllMusicSuccessState extends LofiiiAllMusicState {
  final List<MusicModel> musicList;

  LofiiiAllMusicSuccessState({required this.musicList});

  @override
  List<Object?> get props => [musicList];
}

class LofiiiAllMusicFailureState extends LofiiiAllMusicState {
  final String errorMessage;

  LofiiiAllMusicFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
