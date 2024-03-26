



    import 'package:lofiii/data/datasources/youtube/youtube_playlists_ids.dart';
import 'package:lofiii/data/repositories/youtube_repository.dart';
import 'package:youtube_scrape_api/models/video.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';

import '../../../di/dependency_injection.dart';

class MyYouTubeDataAPI{

    static YoutubeDataApi yt = locator.get<YoutubeDataApi>();


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
    Future<List<Video>> aeloLofi =
    yt.fetchPlayListVideos(YoutubePlaylistsIDs.AeloLofi, 5);

    Future<List<Video>> fasetyaMix =
    yt.fetchPlayListVideos(YoutubePlaylistsIDs.fasetyaMix, 70);

    Future<List<Video>> eternal =
    yt.fetchPlayListVideos(YoutubePlaylistsIDs.EternalLofi, 11);

    Future<List<Video>> saregama =
    yt.fetchPlayListVideos(YoutubePlaylistsIDs.SaregamaLofi, 308);

    Future<List<Video>> tSeriesLofi =
    yt.fetchPlayListVideos(YoutubePlaylistsIDs.tSeriesLofi, 47);

    ///!------------------- Combined List-----------------///
    List<Future<List<Video>>> combinedPlaylistsFuture() {
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


    Future<List<Video>> trendingMusic = yt.fetchTrendingMusic();
    Future<List<Video>> trendingVideos = yt.fetchTrendingVideo();
    Future<List<Video>> trendingGaming = yt.fetchTrendingGaming();
    Future<List<Video>> trendingMovies = yt.fetchTrendingMovies();

    }