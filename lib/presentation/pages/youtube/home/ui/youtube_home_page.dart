import 'package:lofiii/presentation/pages/downloads/exports.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/you_tube_home_whats_hot_today_widget.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/youtube_home_page_sliver_app_bar_widget.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/youtube_home_page_top_music_carousel_widget.dart';

class YouTubeHomePage extends StatelessWidget {
  const YouTubeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ///--------------------------- APPBAR ---------------------------------///
          const YoutubeHomePageSliverAppBarWidget(),
          SliverGap(0.02.sh),

          ///---------------------- TOP MUSIC CAROUSEL CARD WIDGET ------------------///
          const YoutubeHomePageTopMusicCarouselWidget(),

          SliverGap(0.02.sh),

          ///------------------- What's Hot Today --------------------------///
          const YouTubeHomeWhatsHotTodayWidget(),
        ],
      ),
    );
  }
}

