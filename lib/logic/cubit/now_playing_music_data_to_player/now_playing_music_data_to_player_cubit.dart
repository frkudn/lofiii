import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_music_data_to_player_state.dart';

// Defining the Cubit class for sending current playing music data to the player.
class NowPlayingMusicDataToPlayerCubit
    extends Cubit<NowPlayingMusicDataToPlayerState> {
  // Constructor for the cubit, initializing it with default music data.
  NowPlayingMusicDataToPlayerCubit()
      : super(const NowPlayingMusicDataToPlayerState(
            musicThumbnail: null,
            musicIndex: 0,
            musicList: [],
            musicTitle: "Unknown",
            musicArtist: "Unknown",
            musicListLength: 0,
            uri: "",
            musicId: 0));

  //! Method to send updated music data to the player.
  sendDataToPlayer({
    required int musicIndex,
    required musicList,
    required musicThumbnail,
    required  musicTitle,
    required uri,
    required musicId,
   required musicArtist,
   required musicListLength,
  }) {
    // Emitting a new state with updated music data.
    emit(state.copyWith(
        musicThumbnail: musicThumbnail,
        musicList: musicList,
        musicIndex: musicIndex,
        musicTitle: musicTitle,
        musicArtist: musicArtist,
        musicListLength: musicListLength,
        uri: uri,
        musicId: musicId));
  }
}
