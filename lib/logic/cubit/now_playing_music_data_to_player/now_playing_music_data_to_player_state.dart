// ignore_for_file: prefer_typing_uninitialized_variables

part of 'now_playing_music_data_to_player_cubit.dart';

@immutable
class NowPlayingMusicDataToPlayerState extends Equatable {
  const NowPlayingMusicDataToPlayerState(
      {required this.musicIndex,
      required this.musicList,
      required this.musicTitle,
      required this.musicThumbnail,
      required this.musicArtist,
      required this.musicListLength,
      required this.uri,
      required this.musicId});

  final int musicIndex;
  final musicList;
  final String musicTitle;
  final musicThumbnail;
  final  musicArtist;
  final musicListLength;
  final uri;
  final int musicId;

  NowPlayingMusicDataToPlayerState copyWith(
      {musicIndex,
      musicList,
      musicTitle,
      musicThumbnail,
      musicArtist,
      musicListLength,
      uri,
      musicId}) {
    return NowPlayingMusicDataToPlayerState(
        musicIndex: musicIndex ?? this.musicIndex,
        musicList: musicList ?? this.musicList,
        musicTitle: musicTitle ?? this.musicTitle,
        musicThumbnail: musicThumbnail ?? this.musicThumbnail,
        musicArtist: musicArtist ?? this.musicArtist,
        musicListLength: musicListLength ?? this.musicListLength,
        uri: uri ?? this.uri,
        musicId: musicId ?? this.musicId);
  }

  @override
  List<Object?> get props => [
        musicIndex,
        musicList,
        musicThumbnail,
        musicArtist,
        musicListLength,
        uri,
        musicTitle
      ];
}
