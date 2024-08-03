
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/data/services/notification_service.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/logic/bloc/download/download_music_bloc.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/lofiii_vibes_music/lofiii_vibes_music_bloc.dart';
import 'package:lofiii/logic/cubit/flip_card/flip_card_cubit.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/repeat_music/repeat_music_cubit.dart';
import 'package:lofiii/logic/cubit/youtube_music/youtube_music_cubit.dart';
import 'package:lofiii/presentation/pages/splash/splash_page.dart';
import 'package:lofiii/resources/hive/hive_resources.dart';
import 'package:nested/nested.dart';
import 'package:one_context/one_context.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'logic/bloc/artists_data/artists_data_bloc.dart';
import 'logic/bloc/check_internet_connection/check_internet_connection_bloc.dart';
import 'logic/bloc/favorite_button/favorite_button_bloc.dart';
import 'logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import 'logic/bloc/lofiii_popular_music/lofiii_popular_music_bloc.dart';
import 'logic/bloc/lofiii_special_music/lofiii_special_music_bloc.dart';
import 'logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_bloc.dart';
import 'logic/bloc/player/music_player_bloc.dart';
import 'logic/bloc/user_profie/user_profile_bloc.dart';
import 'logic/cubit/bottom_navigation_change_page_index/bottom_navigation_index_cubit.dart';
import 'logic/cubit/chnage_system_volume/chnage_system_volume_cubit.dart';
import 'logic/cubit/greeting/greeting_cubit.dart';
import 'logic/cubit/gridview_max_count/gridview_max_cout_cubit.dart';
import 'logic/cubit/search_system/search_system_cubit.dart';
import 'logic/cubit/searchable_list_scroll_controller/searchableList_scroll_controller_cubit.dart';
import 'logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import 'logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import 'logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import 'resources/theme/themes.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///--- Initialize Get It
  initializeLocator();

  ///--- Initialize Notification
  NotificationService().initNotification();

  // The following line will enable the Android and iOS wakelock.
  WakelockPlus.enable();



  //!  Initialize Hive Database
  await MyHive.initializeHive();

  //! Setting preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void dispose() {
    // TODO: implement dispose
    locator.get<ScrollController>().dispose();
    locator.get<Floating>().dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider for managing multiple BLoCs
    return MultiBlocProvider(
      providers: _providers(),

      //!     Initializing ScreenUtil for screen adaptation
      child: ScreenUtilInit(
        splitScreenMode: true,
        //!    Building the application with proper theme
        builder: (context, child) =>
            BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            return MaterialApp(
              ///!--- State is DarkMode
              theme: state.isDarkMode
                  ? Themes.darkTheme.copyWith(
                      ///!---  State is BlackMode
                      scaffoldBackgroundColor:
                          state.isBlackMode ? Colors.black : null,
                      primaryColor: state.isBlackMode ? Colors.black : null,
                      appBarTheme: AppBarTheme(
                          backgroundColor:
                              state.isBlackMode ? Colors.black : null),
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: Color(state.accentColor),
                          brightness: state.isDarkMode
                              ? Brightness.dark
                              : Brightness.light),
                    )
                  :

                  ///!---  State is not DarkMode
                  Themes.lightTheme,
              title: 'LOFIII',
              home: const SplashPage(),
              debugShowCheckedModeBanner: false,
              builder: OneContext().builder,
              navigatorKey: OneContext().key,
            );
          },
        ),
      ),
    );
  }

  ///?----------------   B L O C   P R O V I D E R S   -------------///
  ///////////////////////////////////////////////////////////////////
  List<SingleChildWidget> _providers() {
    return [
      BlocProvider(create: (context) => BottomNavigationIndexCubit(),),
      BlocProvider(create: (context) => ThemeModeCubit(),),
      BlocProvider(create: (context) => MusicPlayerBloc(),),
      BlocProvider(create: (context) => LofiiiSpecialMusicBloc(),),
      BlocProvider(create: (context) => LofiiiPopularMusicBloc(),),
      BlocProvider(create: (context) => LofiiiTopPicksMusicBloc(),),
      BlocProvider(create: (context) => LofiiiAllMusicBloc(),),
      BlocProvider(create: (context) => LofiiiVibesMusicBloc(),),
      BlocProvider(create: (context) => ArtistsDataBloc(),),
      BlocProvider(create: (context) => CurrentlyPlayingMusicDataToPlayerCubit(),),
      BlocProvider(create: (context) => ShowMiniPlayerCubit(),),
      BlocProvider(create: (context) => GreetingCubit(),),
      BlocProvider(create: (context) => CheckInternetConnectionBloc(),),
      BlocProvider(create: (context) => SearchSystemCubit(),),
      BlocProvider(create: (context) => GridviewMaxCountCubit(),),
      BlocProvider(create: (context) => ChangeSystemVolumeCubit(),),
      BlocProvider(create: (context) => FavoriteButtonBloc()),
      BlocProvider(create: (context) => RepeatMusicCubit()),
      BlocProvider(create: (context) => DownloadMusicBloc()),
      BlocProvider(create: (context) => UserProfileBloc()),
      BlocProvider(create: (context) => FlipCardCubit()),
      BlocProvider(create: (context) => FetchMusicFromLocalStorageBloc()),
      BlocProvider(create: (context) => NowPlayingOfflineMusicDataToPlayerCubit()),
      BlocProvider(create: (context) => SearchableListScrollControllerCubit()),
      BlocProvider(create: (context) => YoutubeMusicCubit()),
      BlocProvider(create: (context) => YoutubeMusicPlayerCubit()),

    ];
  }
}

