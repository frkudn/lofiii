import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicPlayerVolumeGestureANDMusicPlayPauseWidget extends StatelessWidget {
  const LocalMusicPlayerVolumeGestureANDMusicPlayPauseWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.1.sh,
      height: 0.6.sh,
      width: 1.sw,
      child: GestureDetector(
        onDoubleTap: () {
          ///!-------------On Double Tap on Cover Image Pause/Play the Music
          context
              .read<MusicPlayerBloc>()
              .add(MusicPlayerTogglePlayPauseEvent());
          log("Double Tap on Cover Image is Clicked!");
        },
        onVerticalDragUpdate: (details) {
          ///!----------  Change System Volume
          context
              .read<ChangeSystemVolumeCubit>()
              .change(details: details, context: context);
          log("onVerticalDragUpdate on Cover Image!");
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
