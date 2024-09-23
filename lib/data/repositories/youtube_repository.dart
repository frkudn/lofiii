import 'package:lofiii/data/models/youtube_video_model.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../providers/youtube/my_youtube_data_provider.dart';

class YouTubeDataRepository {
  final MyYouTubeDataProvider _myYouTubeDataProvider =
      locator<MyYouTubeDataProvider>();

  /// Fetches trending music and returns a list of YoutubeVideoModel
  // Future<List<YoutubeVideoModel>> fetchTrendingMusic() async {
  //   try {

  //     ///-----using youtube_scripe_api package to fetch trending music-------///
  //     final trendingMusic = await _myYouTubeDataProvider.fetchTrendingMusic;

  //     List<YoutubeVideoModel> videos = await Future.wait(
  //             trendingMusic.map((e) => _fetchVideoInfo(e.videoId, e.views))) ??
  //         [];

  //     return videos;
  //   } catch (e) {
  //     throw Exception('Failed to fetch trending music: $e');
  //   }
  // }


Future<List<YoutubeVideoModel>> fetchTrendingMusic() async {
  try {
    // Fetch the initial list of trending music videos
    final trendingMusic = await _myYouTubeDataProvider.fetchTrendingMusic;
    
    // Define a batch size for processing videos
    // This helps manage memory usage and can improve performance
    const batchSize = 10;
    
    // Initialize an empty list to store all processed videos
    List<YoutubeVideoModel> allVideos = [];

    // Process videos in batches
    for (var i = 0; i < trendingMusic.length; i += batchSize) {
      // Calculate the end index for the current batch
      // Ensure we don't go out of bounds for the last batch
      final endIndex = (i + batchSize < trendingMusic.length) 
          ? i + batchSize 
          : trendingMusic.length;
      
      // Extract a subset of videos for this batch
      final batch = trendingMusic.sublist(i, endIndex);

      // Process the batch of videos concurrently
      // This allows for parallel API calls within each batch
      final batchVideos = await Future.wait(
        batch.map((e) => _fetchVideoInfo(e.videoId, e.views,))
      );

      // Add the processed videos from this batch to the main list
      allVideos.addAll(batchVideos);
    }

    // Return the complete list of processed videos
    return allVideos;
  } catch (e) {
    // If an error occurs at any point, throw an exception with details
    throw Exception('Failed to fetch trending music: $e');
  }
}




  /// Fetches detailed video information for a given videoId using youtube_explode_dart package
  Future<YoutubeVideoModel> _fetchVideoInfo(
      String? videoId, String? videoViews) async {
    try {
      Video video = await ytExplode.videos.get(videoId);
      Channel channel = await ytExplode.channels.get(video.channelId);

      return _convertToCustomModel(video, videoViews, channel);
    } catch (e) {
      throw Exception('Failed to fetch video info for $videoId: $e');
    }
  }

  /// Converts Youtube Explode's Video model to custom YoutubeVideoModel
  YoutubeVideoModel _convertToCustomModel(
      Video video, String? views, Channel channel) {
    return YoutubeVideoModel(
        title: video.title,
        author: video.author,
        description: video.description,
        views: views,
        engagement: video.engagement,
        channelId: video.channelId,
        channel: channel,
        hasWatchPage: video.hasWatchPage,
        url: video.url,
        id: video.id,
        isLive: video.isLive,
        keywords: video.keywords,
        hashCode: video.hashCode,
        thumbnails: video.thumbnails,
        duration: video.duration,
        publishDate: video.publishDate,
        uploadDate: video.uploadDate,
        uploadDateRaw: video.uploadDateRaw);
  }

  /// Dispose method to close YoutubeExplode client
  void dispose() {
    ytExplode.close();
  }
}

//----- Using these packages --------------///
// final  ytExplode = locator<YoutubeExplode>();
// final  ytScrape = locator<YoutubeDataApi>();