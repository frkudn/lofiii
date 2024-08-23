import 'package:flutter/material.dart';
import 'package:lofiii/base/router/app_routes.dart';
import 'package:lofiii/presentation/pages/downloads/ui/downloads_page.dart';
import 'package:lofiii/presentation/pages/initial/ui/initial_page.dart';
import 'package:lofiii/presentation/pages/library/library_page.dart';
import 'package:lofiii/presentation/pages/onboarding/ui/onboarding_page.dart';
import 'package:lofiii/presentation/pages/view-more-online-music/ui/online_music_view_more_page.dart';
import 'package:lofiii/presentation/pages/player/offline/ui/offline_player_page.dart';
import 'package:lofiii/presentation/pages/player/online/ui/online_player_page.dart';
import 'package:lofiii/presentation/pages/settings/about/ui/about_page.dart';
import 'package:lofiii/presentation/pages/settings/privacy-policy/ui/privacy_policy.dart';
import 'package:lofiii/presentation/pages/user-profile/ui/profile_page.dart';
import 'package:lofiii/presentation/pages/settings/main/ui/settings.dart';
import 'package:lofiii/presentation/pages/single-artist/ui/single_online_music_artist_page.dart';
import 'package:lofiii/presentation/pages/splash/ui/splash_page.dart';
import 'package:lofiii/presentation/pages/youtube/home/ui/youtube_home_page.dart';
import 'package:lofiii/presentation/pages/youtube/player/ui/youtube_player_page.dart';
import 'package:lofiii/presentation/pages/youtube/search/ui/youtube_search_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingPage());
      case AppRoutes.initialRoute:
        return MaterialPageRoute(builder: (_) => const InitialPage());
      case AppRoutes.youtubeMusicRoute:
        return MaterialPageRoute(builder: (_) => const YouTubeHomePage());
      case AppRoutes.libraryRoute:
        return MaterialPageRoute(builder: (_) => const LibraryPage());
      case AppRoutes.downloadsRoute:
        return MaterialPageRoute(builder: (_) => const DownloadsPage());
      case AppRoutes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.aboutRoute:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case AppRoutes.userProfileRoute:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case AppRoutes.privacyPolicyRoute:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());

      case AppRoutes.youtubeMusicSearchRoute:
        return MaterialPageRoute(builder: (_) => const YouTubeSearchPage());
      case AppRoutes.singleOnlineMusicArtistRoute:
        return MaterialPageRoute(builder: (_) {
          Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          return SingleOnlineMusicArtistPage(
            artistName: arguments["artistName"],
            image: arguments["image"],
          );
        });
      case AppRoutes.viewMoreOnlineMusicRoute:
        return MaterialPageRoute(builder: (_) {
          Map<String, dynamic> arguments =
              settings.arguments as Map<String, dynamic>;
          return ViewMoreOnlineMusicPage(
            musicList: arguments["musicList"],
            topHeading: arguments["topHeading"],
          );
        });
      case AppRoutes.onlinePlayerRoute:
        return MaterialPageRoute(builder: (_) => const OnlinePlayerPage());
      case AppRoutes.offlinePlayerRoute:
        return MaterialPageRoute(builder: (_) => const OfflinePlayerPage());
      case AppRoutes.youtubeMusicPlayerRoute:
        return MaterialPageRoute(builder: (_) => const YouTubeMusicPlayerPage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
