import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lofiii/base/router/app_routes.dart';
import 'package:lofiii/logic/bloc/fetch_lofiii_music_from_internet/lofiii_music_bloc.dart';
import '../../../../base/services/app_services.dart';
import '../../../../logic/cubit/greeting/greeting_cubit.dart';
import '../../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../../base/services/hive/hive_services.dart';
import '../../../../base/assets/app_assets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _fetchMusic();
    //?---------Navigate To OnBoarding/Initial Page After Three Seconds-----////
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
                      ? AppSvgsImages.lofiiiLogoDarkModeSvg
                      : AppSvgsImages.lofiiiLogoLightModeSvg,
                  fit: BoxFit.contain,
                ),
              ),

              ///---- App Version Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    AppServices.appFullVersion,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ///!------------------------- M E T H O D S ------------------////
  goToNextPage() async {
    ///----!  Fetch Bool value from Hive database , to show OnBoarding Screen or not
    final bool onBoarding = await MyHiveBoxes.settingBox
            .get(MyHiveKeys.showOnBoardingScreenHiveKey) ??
        true;

    ///!-----    Navigate To Next Screen
    Future.delayed(const Duration(seconds: 2), () {
      if (onBoarding) {
        Navigator.pushReplacementNamed(context, AppRoutes.onBoardingRoute);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.initialRoute);
      }
    });
  }

  _fetchMusic() {
    //?-----------Fetch LOFIII  Music ------___--------///
    context.read<LofiiiMusicBloc>().add(LOFIIIMusicFetchEvent());

    //?-------------Update Home Page Greeting Message -------/////
    context.read<GreetingCubit>().updateGreeting();
  }
}
