import 'package:lofiii/data/repositories/youtube_repository.dart';
import 'package:lofiii/exports.dart';
import 'package:lofiii/logic/bloc/youtube_videos_bloc/youtube_videos_bloc.dart';



///?----------------   B L O C   P R O V I D E R S   -------------///
///////////////////////////////////////////////////////////////////
List<SingleChildWidget> myBlocProviders() {
  return [
    BlocProvider(
      create: (context) => BottomNavigationIndexCubit(),
    ),
    BlocProvider(
      create: (context) => ThemeModeCubit(),
    ),
    BlocProvider(
      create: (context) => MusicPlayerBloc(),
    ),
    BlocProvider(
      create: (context) => LofiiiMusicBloc(),
    ),
    BlocProvider(
      create: (context) => ShowMiniPlayerCubit(),
    ),
    BlocProvider(
      create: (context) => GreetingCubit(),
    ),
    BlocProvider(
      create: (context) => CheckInternetConnectionBloc(),
    ),
    BlocProvider(
      create: (context) => LofiiiMusicSearchSystemCubit(),
    ),
    BlocProvider(
      create: (context) => GridViewMaxCountCubit(),
    ),
    BlocProvider(
      create: (context) => ChangeSystemVolumeCubit(),
    ),
    BlocProvider(
      create: (context) => OnlineMusicFavoriteButtonBloc(),
    ),
    BlocProvider(
      create: (context) => RepeatMusicCubit(),
    ),
    BlocProvider(
      create: (context) => DownloadMusicBloc(),
    ),
    BlocProvider(
      create: (context) => UserProfileBloc(),
    ),
    BlocProvider(
      create: (context) => FlipCardCubit(),
    ),
    BlocProvider(
      create: (context) => FetchMusicFromLocalStorageBloc(),
    ),
    BlocProvider(
      create: (context) => NowPlayingMusicDataToPlayerCubit(),
    ),
    BlocProvider(
      create: (context) => SearchableListScrollControllerCubit(),
    ),
    BlocProvider(
      create: (context) => YoutubeMusicPlayerCubit(),
    ),
    BlocProvider(
      create: (context) => LocalMusicToFavoriteMusicListCubit(),
    ),
    BlocProvider(
      create: (context) => FetchFavoriteMusicFromLocalStorageBloc(),
    ),
    BlocProvider(
      create: (context) => YoutubeCarouselIndicatorsIndexCubit(),
    ),

      BlocProvider(
      create: (context) => YoutubeVideosBloc(ytRepository: locator<YouTubeDataRepository>()),
    ),
  ];
}
