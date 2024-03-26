import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lofiii/data/datasources/youtube/youtube_playlists_ids.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_scrape_api/models/video.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

import '../../../data/repositories/youtube_repository.dart';

part 'youtube_music_state.dart';

class YoutubeMusicCubit extends Cubit<YoutubeMusicState> {
  YoutubeDataApi yt = locator.get<YoutubeDataApi>();
  YouTubeDataRepository ytRepo = locator.get<YouTubeDataRepository>();
  YoutubeMusicCubit() : super(YoutubeMusicInitialState());

  fetchMusic() {
    emit(YoutubeMusicLoadingState());

    try {
      ///------------Emit Success State--------------///
      emit(YoutubeMusicSuccessState(
        musicList: ytRepo.trendingMusic(),
        favoriteFuturePlayLists: ytRepo.combinedPlaylistsFuture(),
      ));
    }

    ///------------------- if Error -----------------------------///
    catch (e) {
      emit(YoutubeMusicErrorState(errorMessage: e.toString()));
    }
  }

  searchMusic({required query}) async {
    emit(YoutubeMusicLoadingState());
    try {
      Future<List<Video>> searchList = yt.fetchSearchVideo(query);
      Future<List<String>> searchSuggestion = yt.fetchSuggestions(query);
      emit(YoutubeMusicSearchState(
          searchList: searchList, searchSuggestions: searchSuggestion));
    } catch (e) {
      emit(YoutubeMusicErrorState(errorMessage: e.toString()));
    }
  }
}
