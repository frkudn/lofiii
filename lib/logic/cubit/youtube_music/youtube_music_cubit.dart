import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lofiii/data/datasources/youtube/youtube_playlists_ids.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_scrape_api/models/video.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

part 'youtube_music_state.dart';

class YoutubeMusicCubit extends Cubit<YoutubeMusicState> {
  final YoutubeDataApi yt = locator.get<YoutubeDataApi>();
  YoutubeMusicCubit() : super(YoutubeMusicInitialState());

  fetchMusic() {
    emit(YoutubeMusicLoadingState());

    try {
      ///!---------------------------Future Lists--------------------------------///

      Future<List<Video>> bollywoodLofi = yt.fetchPlayListVideos(
          YoutubePlaylistsIDs.bollywoodLofiYoutubeMusicOrignal, 73);
      Future<List<Video>> gravero =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.mashupByGravero, 17);
      Future<List<Video>> afterMorning =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.aftermorningRevolved, 18);
      Future<List<Video>> bollywoodChill =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.bollywoodChill, 38);
      Future<List<Video>> fasetyaFavorite =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.fasetyaFavorite, 61);
      Future<List<Video>> aeloLofi = yt.fetchPlayListVideos(YoutubePlaylistsIDs.AeloLofi, 5);

      Future<List<Video>> fasetyaMix =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.fasetyaMix, 70);

      Future<List<Video>> eternal =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.EternalLofi, 11);

      Future<List<Video>> saregama =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.SaregamaLofi, 308);

      Future<List<Video>> tSeriesLofi =
          yt.fetchPlayListVideos(YoutubePlaylistsIDs.tSeriesLofi, 47);

      ///!------------------- Combined List-----------------///
      List<Future<List<Video>>> combinedFuture() {
        return [
          bollywoodLofi,
          gravero,
          afterMorning,
          fasetyaFavorite,
          fasetyaMix,
          aeloLofi,
          eternal,
          bollywoodChill,
          saregama,
          tSeriesLofi,
        ];
      }

      ///------------Emit Success State--------------///
      emit(YoutubeMusicSuccessState(
        musicList: yt.fetchTrendingMusic(),
        favoriteFuturePlayLists: combinedFuture(),
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
      emit(YoutubeMusicSearchState(searchList: searchList));
    } catch (e) {
      emit(YoutubeMusicErrorState(errorMessage: e.toString()));
    }
  }
}
