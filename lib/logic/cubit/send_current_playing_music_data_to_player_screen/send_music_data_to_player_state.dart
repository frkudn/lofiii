part of 'send_music_data_to_player_cubit.dart';

@immutable
 class FetchCurrentPlayingMusicDataToPlayerState extends Equatable{

  const FetchCurrentPlayingMusicDataToPlayerState({required this.musicIndex, required this.fullMusicList,required this.youtubeMusicList});

  final int musicIndex;
  final List<MusicModel> fullMusicList;
  final List<Video> youtubeMusicList;

  FetchCurrentPlayingMusicDataToPlayerState copyWith ({ musicIndex,  fullMusicList, youtubeMusicList}){
    return FetchCurrentPlayingMusicDataToPlayerState(musicIndex: musicIndex?? this.musicIndex,  fullMusicList: fullMusicList?? this.fullMusicList, youtubeMusicList: youtubeMusicList??this.youtubeMusicList);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [musicIndex, fullMusicList,youtubeMusicList];
}


