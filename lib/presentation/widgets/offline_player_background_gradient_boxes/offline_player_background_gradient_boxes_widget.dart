import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class OfflinePlayerBackgroundGradientBoxesWidget extends StatelessWidget {
  const OfflinePlayerBackgroundGradientBoxesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: SweepGradient(
                      startAngle: 0,
                      center: Alignment.bottomCenter,
                      colors: [
                    Color(themeState.accentColor),
                    Color.fromARGB(217, 228, 220, 224),
                    Color.fromARGB(255, 177, 170, 170),
                    Color.fromARGB(255, 194, 184, 184),
                  ])),
            ),

            ///!--------- Center Circle Rotating Box
            BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
              builder: (context, state) {
                ///!----- If Music Player is Success State
                if (state is MusicPlayerSuccessState) {
                  return StreamBuilder(
                      stream: state.playingStream,
                      builder: (context, snapshot) {
                        ///!------ If music state is playing
                        if (snapshot.data == true) {
                          return Stack(
                            children: [
                              Flash(
                                duration: const Duration(seconds: 8),
                                animate: true,
                                infinite: true,
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: SweepGradient(
                                          startAngle: 6,
                                          center: Alignment.bottomLeft,
                                          colors: [
                                        Color(themeState.accentColor)
                                            .withOpacity(0.8),
                                        Color(themeState.accentColor)
                                            .withOpacity(0.9),
                                        Color(themeState.accentColor),
                                        Color(themeState.accentColor),
                                      ])),
                                ),
                              ),
                              Spin(
                                infinite: true,
                                duration: const Duration(seconds: 10),
                                child: Center(
                                  child: Container(
                                    width: 0.35.sw,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      ///!---- Border
                                      border: Border.all(
                                          color: Color(themeState.accentColor),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        ///!------ If music state is pause
                        else {
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
  }
}
