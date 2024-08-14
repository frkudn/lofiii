import 'package:equatable/equatable.dart';

import '../../../data/models/music_model.dart';

abstract class LofiiiTopPicksMusicState extends Equatable {}

class LofiiiTopPicksMusicInitial extends LofiiiTopPicksMusicState {
  @override
  List<Object?> get props => [];
}

class LofiiiTopPicksMusicLoadingState extends LofiiiTopPicksMusicState {
  @override
  List<Object?> get props => [];
}

class LofiiiTopPicksMusicSuccessState extends LofiiiTopPicksMusicState {
  final List<MusicModel> musicList;

  LofiiiTopPicksMusicSuccessState({required this.musicList});

  @override
  List<Object?> get props => [musicList];
}

class LofiiiTopPicksMusicFailureState extends LofiiiTopPicksMusicState {
  final String errorMessage;

  LofiiiTopPicksMusicFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
