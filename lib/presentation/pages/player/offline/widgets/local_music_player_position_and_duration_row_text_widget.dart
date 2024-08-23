import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicPlayerPositionAndDurationRowTextWidget extends StatelessWidget {
  const LocalMusicPlayerPositionAndDurationRowTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        ///! ----      MusicPlayerSuccessState
        if (state is MusicPlayerSuccessState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.spMax),
            child: StreamBuilder(
                stream: state.combinedStreamPositionAndDurationAndBufferedList,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    final positionSnapshot = snapshot.data!.first;
                    final durationSnapshot = snapshot.data![1];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///!----  Position    ----///
                        Text(
                          FormatDuration.format(positionSnapshot),
                          style: const TextStyle(color: Colors.white),
                        ),

                        ///-!----    Duration Stream   -----////
                        Text(
                          FormatDuration.format(durationSnapshot),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  } else {
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///!----  Position    ----///
                        Text(
                          "00:00",
                          style: TextStyle(color: Colors.white),
                        ),

                        ///-!----    Duration Stream   -----////
                        Text(
                          "00:00",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  }
                }),
          );
        }

        ///! ----      MusicPlayerLoadingState  and FailureState
        else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.spMax),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "00:00",
                  style: TextStyle(),
                ),
                Text(
                  "00:00",
                  style: TextStyle(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
