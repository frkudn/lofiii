import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_music_data_to_player/now_playing_music_data_to_player_cubit.dart';

import '../../../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class OfflinePlayerBackgroundGradientBoxesWidget extends StatelessWidget {
  const OfflinePlayerBackgroundGradientBoxesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        bool blackmode = themeState.isBlackMode;
        bool darkmode = themeState.isDarkMode;
        Color accentColor = Color(themeState.accentColor);

        return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
            NowPlayingMusicDataToPlayerState>(
          builder: (context, nowPlayingState) {
            return Stack(
              children: [
                // Background Color depending on the mode
                Container(
                  color: blackmode
                      ? Colors.black
                      : darkmode
                          ? const Color(0xFF1C1C1E) // Darker tone for dark mode
                          : const Color.fromARGB(226, 113, 82,
                              103), // Light grey for light mode to contrast white elements
                ),

                // Blurred Overlay to mimic Apple Music's modern look
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),

                // Center Circle with subtle shadow for depth
                if (nowPlayingState.musicThumbnail == null)
                  Center(
                    child: Container(
                      width: 0.5.sw,
                      height: 0.5.sw,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Music Player Animations and Rotating Circle
                if (nowPlayingState.musicThumbnail == null)
                  BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                    builder: (context, state) {
                      if (state is MusicPlayerSuccessState) {
                        return StreamBuilder(
                            stream: state.playingStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return Stack(
                                  children: [
                                    Spin(
                                      infinite: true,
                                      duration: const Duration(seconds: 10),
                                      child: Center(
                                        child: Container(
                                          width: 0.4.sw,
                                          height: 0.4.sw,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  accentColor.withOpacity(0.6),
                                              width: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: 0.3.sw,
                                        height: 0.3.sw,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accentColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            });
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
