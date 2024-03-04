import 'package:equatable/equatable.dart';

import '../../../data/models/music_model.dart';





abstract class LofiiiTopPicksMusicState extends Equatable {}


class LofiiiTopPicksMusicInitial extends LofiiiTopPicksMusicState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class LofiiiTopPicksMusicLoadingState extends LofiiiTopPicksMusicState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LofiiiTopPicksMusicSuccessState extends LofiiiTopPicksMusicState{


  final List<MusicModel> musicList;

  LofiiiTopPicksMusicSuccessState({required this.musicList});

  @override
  // TODO: implement props
  List<Object?> get props => [musicList];
}


class LofiiiTopPicksMusicFailureState extends LofiiiTopPicksMusicState {


  final String errorMessage;

  LofiiiTopPicksMusicFailureState({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
