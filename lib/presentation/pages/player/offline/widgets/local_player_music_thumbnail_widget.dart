import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalPlayerMusicThumbnailWidget extends StatelessWidget {
  const LocalPlayerMusicThumbnailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, state) {
        return Positioned(
          top: 0.15.sh,
          height: 0.45.sh,
          width: 1.sw,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0.04.sw),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 2,
                  blurStyle: BlurStyle.outer,
                )
              ],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: MemoryImage(state.musicThumbnail!),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
