


import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

import '../../../logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';

class MyYouTubeVideoPlayerWidget extends StatefulWidget {
  MyYouTubeVideoPlayerWidget({
    super.key,
    required this.playerState
  });
  YoutubeMusicPlayerSuccessState playerState;

  @override
  State<MyYouTubeVideoPlayerWidget> createState() => _MyYouTubeVideoPlayerWidgetState();
}

class _MyYouTubeVideoPlayerWidgetState extends State<MyYouTubeVideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      matchFrameAspectRatioToVideo: true,
      matchVideoAspectRatioToFrame: true,
      controller: widget.playerState.controller,
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
  }
}