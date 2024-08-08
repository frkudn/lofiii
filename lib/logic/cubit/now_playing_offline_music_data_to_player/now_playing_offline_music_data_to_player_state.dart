part of 'now_playing_offline_music_data_to_player_cubit.dart';



@immutable
class NowPlayingOfflineMusicDataToPlayerState extends Equatable{

  const NowPlayingOfflineMusicDataToPlayerState({required this.musicIndex, required this.musicList, required this.musicTitle, required this.musicArtist, required this.musicListLength,});

  final int musicIndex;
  final List<SongModel> musicList;
  final String musicTitle;
  final  musicArtist;
  final musicListLength;

  NowPlayingOfflineMusicDataToPlayerState copyWith ({ musicIndex,  musicList, musicTitle, musicArtist, musicListLength, }){
    return NowPlayingOfflineMusicDataToPlayerState(musicIndex: musicIndex?? this.musicIndex,  musicList: musicList?? this.musicList,musicTitle: musicTitle??this.musicTitle, musicArtist: musicArtist??this.musicArtist,musicListLength: musicListLength?? this.musicListLength,  );
  }

  @override
  List<Object?> get props => [musicIndex, musicList,  musicArtist, musicListLength];
}


