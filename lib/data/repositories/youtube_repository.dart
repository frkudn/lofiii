import 'package:youtube_scrape_api/models/video.dart';

import '../providers/youtube/my_youtube_data_provider.dart';

class YouTubeDataRepository {
  final MyYouTubeDataProvider myYouTubeDataAPI = MyYouTubeDataProvider();

  List<Future<List<Video>>> combinedPlaylistsFuture() {
    return myYouTubeDataAPI.combinedPlaylistsFuture();
  }

  Future<List<Video>> trendingMusic() {
    return myYouTubeDataAPI.trendingMusic;
  }
}
