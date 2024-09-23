import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalPlayerMusicTitleWidget extends StatelessWidget {
  const LocalPlayerMusicTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TextAnimator(
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromRight(),
            atRestEffect: WidgetRestingEffects.wave(),
            state.musicTitle,
            maxLines: 1,
            style: TextStyle(fontSize: 25.sp, color: Colors.white),
          ),
        );
      },
    );
  }
}
