import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'now_playing_offline_music_data_to_player_state.dart';

// Defining the Cubit class for sending current playing music data to the player.
class NowPlayingOfflineMusicDataToPlayerCubit
    extends Cubit<NowPlayingOfflineMusicDataToPlayerState> {
  // Constructor for the cubit, initializing it with default music data.
  NowPlayingOfflineMusicDataToPlayerCubit()
      : super(NowPlayingOfflineMusicDataToPlayerState(
          musicIndex: 0,
          musicList: [],
          musicTitle: "Unknown",
          musicArtist: "Unknown",
          musicListLength: 0,
        ));

  //! Method to send updated music data to the player.
  sendDataToPlayer({
    required int musicIndex,
    required List<SongModel> musicList,
    required String musicTitle,
    musicArtist,
    musicListLength,
  }) {
    // Emitting a new state with updated music data.
    emit(state.copyWith(
      musicList: musicList,
      musicIndex: musicIndex,
      musicTitle: musicTitle,
      musicArtist: musicArtist,
      musicListLength: musicListLength,
    ));
  }
}
