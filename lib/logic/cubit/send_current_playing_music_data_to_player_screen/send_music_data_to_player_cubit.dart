// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:youtube_scrape_api/models/video.dart';

import '../../../data/models/music_model.dart';

part 'send_music_data_to_player_state.dart';

// Defining the Cubit class for sending current playing music data to the player.
class CurrentlyPlayingMusicDataToPlayerCubit
    extends Cubit<FetchCurrentPlayingMusicDataToPlayerState> {
  // Constructor for the cubit, initializing it with default music data.
  CurrentlyPlayingMusicDataToPlayerCubit()
      : super(const FetchCurrentPlayingMusicDataToPlayerState(
            fullMusicList: [],musicIndex: 0,youtubeMusicList: []));

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


  sendYouTubeDataToPlayer({required List<Video> youtubeList, musicIndex}){
    emit(state.copyWith(youtubeMusicList: youtubeList,musicIndex: musicIndex));
  }
}
