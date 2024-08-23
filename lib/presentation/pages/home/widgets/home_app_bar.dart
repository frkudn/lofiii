import 'dart:developer';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/base/router/app_routes.dart';
import 'package:lofiii/logic/bloc/fetch_lofiii_music_from_internet/lofiii_music_bloc.dart';
import '../../../../logic/bloc/user_profile/user_profile_bloc.dart';
import '../../../../logic/cubit/greeting/greeting_cubit.dart';
import '../../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../../base/assets/app_assets.dart';
import '../../search/online-music/ui/online_music_search_page.dart';

class HomePageSliverAppBar extends StatelessWidget {
  final LofiiiMusicSuccessState lofiiiMusicSuccessState;
  const HomePageSliverAppBar(
      {super.key, required this.lofiiiMusicSuccessState});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 0.1.sh,
      elevation: 0,
      // backgroundColor: Colors.amber,
      floating: true,
      actions: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.userProfileRoute);
                          },

                          ///!------------       User Profile Image   Avatar  -------////
                          child: BlocBuilder<UserProfileBloc, UserProfileState>(
                            builder: (context, state) {
                              if (state.profileImageFilePath
                                  .toString()
                                  .isNotEmpty) {
                                return SpinPerfect(
                                  child: CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(state.profileImageFilePath),
                                    ),
                                  ),
                                );
                              } else {
                                return BlocBuilder<ThemeModeCubit,
                                    ThemeModeState>(
                                  builder: (context, state) {
                                    return SpinPerfect(
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Color(state.accentColor),
                                        backgroundImage: const AssetImage(
                                            AppSvgsImages
                                                .userDefaultProfileImage),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///!----------    Greeting ----------///
                              BlocBuilder<GreetingCubit, GreetingState>(
                                builder: (context, state) {
                                  return SlideInDown(
                                    child: Text(
                                      state.greeting,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp),
                                    ),
                                  );
                                },
                              ),

                              ///!-------------     User Profile Name   ---------///
                              BlocBuilder<UserProfileBloc, UserProfileState>(
                                builder: (context, state) {
                                  return SlideInUp(
                                    child: Text(
                                      state.username,
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///------Search Icon Button-----///
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnlineMusicSearchPage(
                                  combinedMusicList:
                                      lofiiiMusicSuccessState.combinedMusicList,
                                ),
                              ));
                          log("\n Search Button is Pressed!");
                        },
                        icon: const Icon(EvaIcons.search)),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
