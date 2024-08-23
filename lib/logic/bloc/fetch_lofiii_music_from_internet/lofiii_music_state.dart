part of 'lofiii_music_bloc.dart';

sealed class LofiiiMusicState extends Equatable {
  const LofiiiMusicState();

  @override
  List<Object> get props => [];
}

class LofiiiMusicInitial extends LofiiiMusicState {
  @override
  List<Object> get props => [];
}

class LofiiiMusicLoadingState extends LofiiiMusicState {
  @override
  List<Object> get props => [];
}

class LofiiiMusicSuccessState extends LofiiiMusicState {
  final List<MusicModel> specialMusic;
  final List<MusicModel> popularMusic;
  final List<MusicModel> topPicksMusic;
  final List<MusicModel> vibesMusic;
  final List<MusicModel> combinedMusicList;

  final List<LofiiiArtistModel> artistsMusic;

  const LofiiiMusicSuccessState(
      {required this.specialMusic,
      required this.popularMusic,
      required this.topPicksMusic,
      required this.vibesMusic,
      required this.artistsMusic,
      required this.combinedMusicList});

  @override
  List<Object> get props => [
        specialMusic,
        popularMusic,
        topPicksMusic,
        vibesMusic,
        artistsMusic,
        combinedMusicList
      ];
}

class LofiiiMusicFailureState extends LofiiiMusicState {
  final String errorMessage;

  const LofiiiMusicFailureState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
