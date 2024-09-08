import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalPlayerMusicArtistWidget extends StatelessWidget {
  const LocalPlayerMusicArtistWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, state) {
        return Text(
          state.musicArtist ?? "Unknown",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.sp, color: Colors.white70),
        );
      },
    );
  }
}
