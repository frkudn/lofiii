import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_context/one_context.dart';
import '../../../data/services/app_services.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_event.dart';
import '../../../logic/bloc/lofiii_popular_music/lofiii_popular_music_bloc.dart';
import '../../../logic/bloc/lofiii_special_music/lofiii_special_music_bloc.dart';
import '../../../logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_bloc.dart';
import '../../../logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_event.dart';
import '../../../logic/cubit/greeting/greeting_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../logic/cubit/youtube_music/youtube_music_cubit.dart';
import '../../../resources/hive/hive_resources.dart';
import '../../../resources/my_assets/my_assets.dart';
import '../initial/initial_page.dart';
import '../onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchMusic();

    ///?---------Navigate To OnBoarding/Initial Page After Three Seconds-----////
    goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              
              ///! Logo
              Center(
                child: SvgPicture.asset(
                  state.isDarkMode
                      ? MyAssets.lofiiiLogoDarkModeSvg
                      : MyAssets.lofiiiLogoLightModeSvg,
                  fit: BoxFit.contain,
                ),
              ),


              ///---- App Version Info
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(AppServices.appFullVersion, style: TextStyle(fontSize: 12.sp),),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ///!------------------------- M E T H O D S ------------------////
  Future goToNextPage() async {
    ///----!  Fetch Bool value from Hive database , to show OnBoarding Screen or not
    final bool onBoarding = await MyHiveBoxes.settingBox
            .get(MyHiveKeys.showOnBoardingScreenHiveKey) ??
        true;

    ///!-----    Navigate To Next Screen
    Future.delayed(const Duration(seconds: 2), () {
      if (onBoarding) {
        OneContext().pushReplacement(
            MaterialPageRoute(builder: (context) => const OnBoardingPage()));
      } else {
        OneContext().pushReplacement(
            MaterialPageRoute(builder: (context) => const InitialPage()));
      }
    });
  }

  _fetchMusic() {
    ///?-----------Fetch LOFIII Special Music ------___--------///
    context.read<LofiiiSpecialMusicBloc>().add(LOFIIISpecialMusicFetchEvent());

    ///?-----------Fetch LOFIII Popular Music ------___--------///
    context.read<LofiiiPopularMusicBloc>().add(LOFIIIPopularMusicFetchEvent());

    ///?-----------Fetch LOFIII TopPicks Music ------___--------///
    context
        .read<LofiiiTopPicksMusicBloc>()
        .add(LOFIIITopPicksMusicFetchEvent());

    ///?-----------Fetch LOFIII All Music ------___--------///
    context.read<LofiiiAllMusicBloc>().add(LOFIIIAllMusicFetchEvent());

    ///?-------------Update Home Page Greeting Message -------/////
    context.read<GreetingCubit>().updateGreeting();

    ///?--------------- Fetch Youtube Music ------------------///
    context.read<YoutubeMusicCubit>().fetchMusic();
  }



}
