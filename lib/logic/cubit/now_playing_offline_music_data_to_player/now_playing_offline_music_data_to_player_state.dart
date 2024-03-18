part of 'now_playing_offline_music_data_to_player_cubit.dart';



@immutable
class NowPlayingOfflineMusicDataToPlayerState extends Equatable{

  const NowPlayingOfflineMusicDataToPlayerState({required this.musicIndex, required this.futureMusicList, required this.musicTitle, required this.musicArtist, required this.musicListLength,required this.snapshotMusicList});

  final int musicIndex;
  final Future<List<SongModel>> futureMusicList;
  final List<SongModel>? snapshotMusicList;
  final String musicTitle;
  final  musicArtist;
  final musicListLength;

  NowPlayingOfflineMusicDataToPlayerState copyWith ({ musicIndex,  futureMusicList, musicTitle, musicArtist, musicListLength, snapshotMusicList}){
    return NowPlayingOfflineMusicDataToPlayerState(musicIndex: musicIndex?? this.musicIndex,  futureMusicList: futureMusicList?? this.futureMusicList,musicTitle: musicTitle??this.musicTitle, musicArtist: musicArtist??this.musicArtist,musicListLength: musicListLength?? this.musicListLength, snapshotMusicList: snapshotMusicList??this.snapshotMusicList  );
  }

  @override
  List<Object?> get props => [musicIndex, futureMusicList, snapshotMusicList, musicArtist, musicListLength];
}


