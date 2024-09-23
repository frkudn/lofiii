import 'package:lofiii/exports.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_scrape_api/youtube_scrape_api.dart';


final  ytExplode = locator<YoutubeExplode>();
final  ytScrape = locator<YoutubeDataApi>();

class MyYouTubeDataProvider {
 final fetchTrendingMusic = ytScrape.fetchTrendingMusic();
 
 
}
