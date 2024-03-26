


import 'package:youtube_scrape_api/models/video.dart';

import '../datasources/youtube/my_youtube_data_api.dart';

class YouTubeDataRepository {

  final MyYouTubeDataAPI myYouTubeDataAPI = MyYouTubeDataAPI();



  List<Future<List<Video>>> combinedPlaylistsFuture(){
    return myYouTubeDataAPI.combinedPlaylistsFuture();
  }

  Future<List<Video>>  trendingMusic(){
    return myYouTubeDataAPI.trendingMusic;
  }

  }