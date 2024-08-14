import 'package:flutter/cupertino.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicBackgroundImageFilterWidget extends StatelessWidget {
  const LocalMusicBackgroundImageFilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, state) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(state.musicThumbnail!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
