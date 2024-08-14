
import 'package:equatable/equatable.dart';

import '../../../data/models/music_model.dart';

abstract class LofiiiVibesMusicState extends Equatable {}


class LofiiiVibesMusicInitial extends LofiiiVibesMusicState {
  @override
  List<Object?> get props => [];
}


class LofiiiVibesMusicLoadingState extends LofiiiVibesMusicState{
  @override
  List<Object?> get props => [];
}
class LofiiiVibesMusicSuccessState extends LofiiiVibesMusicState{


  final List<MusicModel> musicList;

  LofiiiVibesMusicSuccessState({required this.musicList});

  @override
  List<Object?> get props => [musicList];
}


class LofiiiVibesMusicFailureState extends LofiiiVibesMusicState {


  final String errorMessage;

  LofiiiVibesMusicFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
