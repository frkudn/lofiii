part of 'send_music_data_to_player_cubit.dart';

@immutable
 class FetchCurrentPlayingMusicDataToPlayerState extends Equatable{

  const FetchCurrentPlayingMusicDataToPlayerState({required this.musicIndex, required this.fullMusicList});

  final int musicIndex;
  final List<MusicModel> fullMusicList;

  FetchCurrentPlayingMusicDataToPlayerState copyWith ({ musicIndex,  fullMusicList}){
    return FetchCurrentPlayingMusicDataToPlayerState(musicIndex: musicIndex?? this.musicIndex,  fullMusicList: fullMusicList?? this.fullMusicList);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [musicIndex, fullMusicList];
}


