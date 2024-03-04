import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/music_model.dart';

part 'send_music_data_to_player_state.dart';

// Defining the Cubit class for sending current playing music data to the player.
class CurrentlyPlayingMusicDataToPlayerCubit
    extends Cubit<FetchCurrentPlayingMusicDataToPlayerState> {
  // Constructor for the cubit, initializing it with default music data.
  CurrentlyPlayingMusicDataToPlayerCubit()
      : super(const FetchCurrentPlayingMusicDataToPlayerState(
            fullMusicList: [],musicIndex: 0));

  // Method to send updated music data to the player.
  sendDataToPlayer(
      {
     required int musicIndex,
        required List<MusicModel> fullMusicList,
      imageUrl}) {
    // Emitting a new state with updated music data.
    emit(state.copyWith(

    fullMusicList: fullMusicList,
      musicIndex: musicIndex,
    ));
  }
}
