import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicPlayerSliderWidget extends StatelessWidget {
  const LocalMusicPlayerSliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        if (state is MusicPlayerSuccessState) {
          return ElasticInRight(
            child: StreamBuilder(
                stream: state.combinedStreamPositionAndDurationAndBufferedList,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.active) {
                    final positionSnapshot = snapshot.data?.first;
                    final durationSnapshot = snapshot.data?[1];
                    final bufferedPositionSnapshot = snapshot.data?.last;

                    return SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 0.01.sh,
                          inactiveTrackColor: Colors.white54),
                      child: Slider(
                          activeColor: Colors.white,
                          secondaryActiveColor: Colors.white.withOpacity(0.5),
                          secondaryTrackValue:
                              bufferedPositionSnapshot!.inSeconds.toDouble(),
                          min: 0,
                          max: durationSnapshot!.inSeconds.toDouble(),
                          value: positionSnapshot!.inSeconds.toDouble(),
                          onChanged: (value) {
                            context.read<MusicPlayerBloc>().add(
                                MusicPlayerSeekEvent(position: value.toInt()));
                          }),
                    );
                  } else {
                    return Slider(
                        activeColor: Colors.transparent,
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
              value: 0.0,
              max: 1,
              min: 0,
              onChanged: (_) {});
        }
      },
    );
  }
}
