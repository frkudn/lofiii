import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pod_player/pod_player.dart';

import '../../../logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';

class MyYouTubeVideoPlayerWidget extends StatelessWidget {
  const MyYouTubeVideoPlayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeMusicPlayerCubit, YoutubeMusicPlayerState>(
      builder: (context, state) {
        if(state is YoutubeMusicPlayerSuccessState) {
          return PodVideoPlayer(
            matchFrameAspectRatioToVideo: true,
            matchVideoAspectRatioToFrame: true,
            controller: state.controller,
            alwaysShowProgressBar: false,
            podProgressBarConfig: const PodProgressBarConfig(
              bufferedBarColor: Colors.transparent,
              alwaysVisibleCircleHandler: false,
              circleHandlerRadius: 0,
              playingBarColor: Colors.transparent,
            ),
            overlayBuilder: (options) {
              return const SizedBox.shrink();
            },
          );
        } else{
          return const SizedBox.shrink();
        }
      },
    );
  }
}