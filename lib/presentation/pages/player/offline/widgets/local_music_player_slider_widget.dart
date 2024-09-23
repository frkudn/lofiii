import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicPlayerSliderWidget extends StatelessWidget {
  const LocalMusicPlayerSliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
            if (state is MusicPlayerSuccessState) {
              return ElasticInRight(
                child: StreamBuilder(
                    stream:
                        state.combinedStreamPositionAndDurationAndBufferedList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done ||
                          snapshot.connectionState == ConnectionState.active) {
                        final positionSnapshot = snapshot.data?.first;
                        final durationSnapshot = snapshot.data?[1];
                        final bufferedPositionSnapshot = snapshot.data?.last;

                        return SliderTheme(
                          data: SliderThemeData(
                            trackHeight: themeState.sliderTrackHeight,
                            inactiveTrackColor: Colors.white54,
                            thumbColor: Colors.white,
                            activeTrackColor: Colors.white,
                            secondaryActiveTrackColor:
                                Colors.white.withOpacity(0.5),
                          ),
                          child: Slider(
                              secondaryTrackValue: bufferedPositionSnapshot!
                                  .inSeconds
                                  .toDouble(),
                              min: 0,
                              max: durationSnapshot!.inSeconds.toDouble(),
                              value: positionSnapshot!.inSeconds.toDouble(),
                              onChangeStart: (_) {
                                context
                                    .read<ThemeModeCubit>()
                                    .changeSliderTrackHeight(
                                        sliderTrackHeight: 0.025.sh);
                              },
                              onChangeEnd: (_) {
                                context
                                    .read<ThemeModeCubit>()
                                    .changeSliderTrackHeight(
                                        sliderTrackHeight: 0.01.sh);
                              },
                              onChanged: (value) {
                                context.read<MusicPlayerBloc>().add(
                                    MusicPlayerSeekEvent(
                                        position: value.toInt()));
                              }),
                        );
                      } else {
                        return Slider(
                            activeColor: Colors.transparent,
                            inactiveColor: Colors.transparent,
                            value: 0.0,
                            max: 1,
                            min: 0,
                            onChanged: (_) {});
                      }
                    }),
              );
            } else {
              return Slider(
                  activeColor: Colors.transparent,
                  inactiveColor: Colors.transparent,
                  value: 0.0,
                  max: 1,
                  min: 0,
                  onChanged: (_) {});
            }
          },
        );
      },
    );
  }
}
