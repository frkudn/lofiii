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
                      startAngle: 3,
                      center: Alignment.bottomLeft,
                      colors: [
                        Color(themeState.accentColor),
                        Colors.cyan,
                        Colors.teal.shade800,
                        Colors.lightGreen.shade800,
                        Color(themeState.accentColor),
                        Colors.purple.shade600,
                        Colors.deepPurple.shade800,
                        Color(themeState.accentColor),
                      ])),
            ),

            ///!--------- Center Circle Rotating Box
            BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
              builder: (context, state) {

                ///!----- If Music Player is Success State
                if(state is MusicPlayerSuccessState) {
                  return StreamBuilder(
                    stream: state.playingStream,
                    builder: (context, snapshot) {
                      ///!------ If music state is playing
                      if(snapshot.data == true) {
                        return Spin(
                          infinite: true,
                          duration: const Duration(seconds: 10),
                          child: Center(
                            child: Container(
                              width: 0.6.sw,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                ///!---- Colors
                                gradient: SweepGradient(
                                    center: Alignment.center,
                                    colors: [
                                      Colors.cyan,
                                      Colors.deepOrange.shade800,
                                      Colors.amber.shade800,
                                      Color(themeState.accentColor),
                                      Colors.teal.shade800,
                                      Colors.pink.shade600,
                                      Colors.red.shade800,
                                    ]),

                                ///!---- Border
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        );
                      }
                      ///!------ If music state is pause
                      else{
                        return const SizedBox.shrink();
                      }
                    }
                  );
                } else{
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