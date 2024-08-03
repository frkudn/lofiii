

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class MiniMusicVisualizerWidget extends StatelessWidget {
  const MiniMusicVisualizerWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return BlocBuilder<MusicPlayerBloc,
            MusicPlayerState>(
          builder: (context, musicState) {
            if (musicState is MusicPlayerSuccessState) {
              return StreamBuilder(
                  stream: musicState.playingStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return SizedBox(
                        width: 0.05.sw,
                        child: MiniMusicVisualizer(
                          color: Color(
                              themeState
                                  .accentColor),
                          height: 0.02.sh,
                          radius: 2,
                          animate: true,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}