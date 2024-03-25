import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:lofiii/logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import 'package:lofiii/utils/format_duration.dart';
import 'package:one_context/one_context.dart';
import 'package:pod_player/pod_player.dart';

import '../../../logic/cubit/chnage_system_volume/chnage_system_volume_cubit.dart';

class YouTubeMusicPlayerPage extends StatefulWidget {
  const YouTubeMusicPlayerPage({
    super.key,
  });

  @override
  State<YouTubeMusicPlayerPage> createState() => _YouTubeMusicPlayerPageState();
}

class _YouTubeMusicPlayerPageState extends State<YouTubeMusicPlayerPage> {
  late ValueNotifier<PodVideoState> videoState;
  late ValueNotifier<int> _videoPosition;
  late ValueNotifier<int> _videoTotalDuration;
  late ValueNotifier<bool> _videoIsBuffering;

  @override
  void initState() {
    _videoPosition = ValueNotifier(0);
    _videoTotalDuration = ValueNotifier(0);
    _videoIsBuffering = ValueNotifier(true);
    videoState = ValueNotifier(PodVideoState.loading);

    super.initState();
  }

  @override
  void dispose() {
    videoState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      bool potrait = orientation == Orientation.portrait;
      bool landscape = orientation == Orientation.landscape;
      return PopScope(
        canPop: true,
        onPopInvoked: (bool) async {
          if (orientation == Orientation.landscape) {
            await SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
        },
        child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, themeState) {
          return BlocBuilder<YoutubeMusicPlayerCubit, YoutubeMusicPlayerState>(
            builder: (context, playerState) {
              if (playerState is YoutubeMusicPlayerSuccessState) {
                final controller = playerState.controller;
                controller.addListener(() {
                  //!----------------- Update value notifiers with new values
                  _videoPosition.value =
                      controller.currentVideoPosition.inSeconds;
                  _videoTotalDuration.value =
                      controller.totalVideoLength.inSeconds;
                  videoState.value = controller.videoState;
                  _videoIsBuffering.value =
                      controller.videoPlayerValue!.isBuffering;
                });

                return Scaffold(
                  backgroundColor: Colors.black,
                  extendBodyBehindAppBar: true,

                  ///!---------------------------- body
                  body: Stack(
                    // alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      ///?--------------------------------------  Player
                      GestureDetector(
                        ///!-------- Show Player Buttons
                        onTap: () async {
                          context
                              .read<YoutubeMusicPlayerCubit>()
                              .showPlayerButtons(state: playerState);
                        },

                        ///!-----------    Play Pause Toggle
                        onDoubleTap: () {
                          playerState.controller.togglePlayPause();
                        },

                        onVerticalDragUpdate: (details) {
                          ///!----------  Change System Volume
                          _changeVolume(context, details);
                        },

                        onHorizontalDragUpdate: (details) async {
                          ///!-------------  Change Video Position
                          _changeVideoPosition(context, details, playerState);
                        },
                        child: Container(
                          height: 1.sh,
                          width: 1.sw,
                          color: Colors.black,

                          ///?-------------------------------------------------------////
                          ////!--------------------------  Player --------------------///
                          ///?-------------------------------------------------------////
                          child: PodVideoPlayer(
                            matchFrameAspectRatioToVideo: true,
                            matchVideoAspectRatioToFrame: true,
                            controller: playerState.controller,
                            alwaysShowProgressBar: false,
                            backgroundColor: Colors.black,
                            overlayBuilder: (options) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),

                      ///!---------  Back Button
                      Visibility(
                        visible: playerState.showPlayerButtons,
                        child: Positioned(
                          left: 0.04.sw,
                          top: 0.08.sh,
                          child: IconButton(
                            onPressed: () async {
                              OneContext().pop();

                              if (orientation == Orientation.landscape) {
                                await SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                              size: potrait ? 30.sp : 16.sp,
                            ),
                          ),
                        ),
                      ),

                      ///!------------------------------- Device Orientation
                      Visibility(
                        visible: playerState.showPlayerButtons,
                        child: Positioned(
                          top: 0.1.sh,
                          right: 0.03.sw,
                          child: IconButton(
                            onPressed: () async {
                              if (orientation == Orientation.portrait) {
                                await SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.landscapeRight]);
                              } else {
                                await SystemChrome.setPreferredOrientations(
                                    [DeviceOrientation.portraitUp]);
                              }
                            },
                            icon: const Icon(
                              Icons.screen_rotation,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      ///?-------------- Show Current Video Position on Horizontal Dragging Only
                      Visibility(
                        visible: playerState.showVideoPositionOnHDragging,
                        child: Positioned(
                          top: potrait ? 0.3.sh : 0.025.sh,
                          width: 1.sw,
                          child: ValueListenableBuilder(
                            valueListenable: _videoPosition,
                            builder: (context, value, child) => Center(
                              child: Text(
                                " ${FormatDuration.format(Duration(seconds: value))}/${FormatDuration.format(Duration(seconds: playerState.controller.totalVideoLength.inSeconds))}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: potrait ? 25.sp : 15.sp),
                              ),
                            ),
                          ),
                        ),
                      ),

                      ///!----------------------------- Player Buttons ----------------------------//

                      _potraitPlayerButtons(
                          playerState, controller, orientation),

                      ///!---------------------------- Landscape Player Buttons ---------------
                      _landscapePlayerButtons(playerState, landscape),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }),
      );
    });
  }

  ///?-----------------------------------------------------------------------------//
  ///!--------------------------- M E T H O D S ----------------------------------///
  ///--------------------------------------------------------------------------///

  ///?--------------------------for P O T R A I T -------------------------------///
  ///!---------------------- Player Buttons Method -------------------------------///
  Positioned _potraitPlayerButtons(YoutubeMusicPlayerSuccessState playerState,
      PodPlayerController controller, orientation) {
    return Positioned(
      bottom: 0.05.sh,
      width: 1.sw,
      child: Visibility(
        visible: playerState.showPlayerButtons &&
            orientation == Orientation.portrait,
        child: Column(
          children: [
            ///!---------- Slider -----------//
            SliderTheme(
              data: _sliderThemeData(),
              child: ValueListenableBuilder(
                valueListenable: _videoPosition,
                builder: (context, value, child) => Slider(
                  min: 0,
                  max: playerState.controller.totalVideoLength.inSeconds
                      .toDouble(),
                  value: value.toDouble(),
                  onChanged: (value) {
                    playerState.controller
                        .videoSeekTo(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            ///!--------------- Video Position Text & Duration Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///!------------ Position
                  ValueListenableBuilder(
                    valueListenable: _videoPosition,
                    builder: (context, value, child) {

                    return  Text(
                        FormatDuration.format(Duration(seconds: value))
                            .toString(),
                        style: const TextStyle(color: Colors.white),
                      );
                    }
                  ),

                  ///!---------Duration
                  ValueListenableBuilder(
                    valueListenable: _videoTotalDuration,
                    builder: (context, value, child) => Text(
                      FormatDuration.format(Duration(seconds: value))
                          .toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            ///!------------------------------------ Buttons ---------------------//
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///!--------------Previous Music Button
                BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                    FetchCurrentPlayingMusicDataToPlayerState>(
                  builder: (context, fetchState) {
                    return IconButton(
                        onPressed: () {
                          if (fetchState.musicIndex > 0) {
                            backwardButtonClicked(
                                fetchState, controller, context);
                          }
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          color: fetchState.musicIndex > 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          size: 40.sp,
                        ));
                  },
                ),

                ///!------------- Backward Button ---------///
                IconButton(
                  onPressed: () {
                    playerState.controller
                        .videoSeekBackward(const Duration(seconds: 5));
                  },
                  icon: Icon(
                    Icons.replay_5_outlined,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),

                ///!------------------- Play Pause Button -----------///
                ValueListenableBuilder(
                  valueListenable: _videoIsBuffering,
                  builder: (context, isBuffering, child) =>
                      ValueListenableBuilder(
                          valueListenable: videoState,
                          builder: (context, value, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                ///!---------If Loading
                                if (isBuffering)
                                  CircularProgressIndicator(
                                    strokeWidth: 10.sp,
                                    color: Colors.white,
                                  ),
                                IconButton(
                                  onPressed: () {
                                    playerState.controller.togglePlayPause();
                                  },
                                  icon: Icon(
                                    value == PodVideoState.playing
                                        ? EvaIcons.pauseCircle
                                        : EvaIcons.playCircle,
                                    color: Colors.white,
                                    size: 45.sp,
                                  ),
                                ),
                              ],
                            );
                          }),
                ),

                ///!------------- Forward Button ---------///
                IconButton(
                  onPressed: () {
                    playerState.controller
                        .videoSeekForward(const Duration(seconds: 5));
                  },
                  icon: Icon(
                    Icons.forward_5_outlined,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),

                ///!--------------Next Music Button
                BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                    FetchCurrentPlayingMusicDataToPlayerState>(
                  builder: (context, fetchState) {
                    return IconButton(
                        onPressed: () {
                          if (fetchState.musicIndex <
                              fetchState.youtubeMusicList.length) {
                            nextMusicButtonClicked(
                                fetchState, controller, context);
                          }
                        },
                        icon: Icon(
                          Icons.skip_next,
                          color: fetchState.musicIndex <
                                  fetchState.youtubeMusicList.length
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          size: 40.sp,
                        ));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///?--------------------------for L A N D S C A P E -------------------------------///
  ///!---------------------- Player Buttons Method -------------------------------///
  Visibility _landscapePlayerButtons(
      YoutubeMusicPlayerSuccessState playerState, bool landscape) {
    return Visibility(
      visible: playerState.showPlayerButtons && landscape,
      child: Stack(
        children: [
          Center(
            child:

                ///!------------------------------------ Buttons ---------------------//
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///!------------- Backward Button ---------///
                IconButton(
                  onPressed: () {
                    playerState.controller
                        .videoSeekBackward(const Duration(seconds: 5));
                  },
                  icon: Icon(
                    Icons.replay_5_outlined,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                ),
                Gap(0.02.sw),

                ///!------------------- Play Pause Button -----------///
                ValueListenableBuilder(
                  valueListenable: _videoIsBuffering,
                  builder: (context, isBuffering, child) =>
                      ValueListenableBuilder(
                          valueListenable: videoState,
                          builder: (context, value, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                ///!---------If Loading
                                if (isBuffering)
                                  CircularProgressIndicator(
                                    strokeWidth: 7.sp,
                                    color: Colors.white,
                                  ),
                                IconButton(
                                  onPressed: () {
                                    playerState.controller.togglePlayPause();
                                  },
                                  icon: Icon(
                                    value == PodVideoState.playing
                                        ? EvaIcons.pauseCircle
                                        : EvaIcons.playCircle,
                                    color: Colors.white,
                                    size: 25.sp,
                                  ),
                                ),
                              ],
                            );
                          }),
                ),

                Gap(0.02.sw),

                ///!------------- Forward Button ---------///
                IconButton(
                  onPressed: () {
                    playerState.controller
                        .videoSeekForward(const Duration(seconds: 5));
                  },
                  icon: Icon(
                    Icons.forward_5_outlined,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.02.sh,
            width: 1.sw,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///!---------- Slider -----------//
                  SliderTheme(
                    data: _sliderThemeData(),
                    child: ValueListenableBuilder(
                      valueListenable: _videoPosition,
                      builder: (context, value, child) => Slider(
                        min: 0,
                        max: playerState.controller.totalVideoLength.inSeconds
                            .toDouble(),
                        value: value.toDouble(),
                        onChanged: (value) {
                          playerState.controller
                              .videoSeekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),

                  ///!--------------- Video Position Text & Duration Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///!------------ Position
                        ValueListenableBuilder(
                          valueListenable: _videoPosition,
                          builder: (context, value, child) => Text(
                            FormatDuration.format(Duration(seconds: value))
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        ///!---------Duration
                        ValueListenableBuilder(
                          valueListenable: _videoTotalDuration,
                          builder: (context, value, child) => Text(
                            FormatDuration.format(Duration(seconds: value))
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///!--- Change Volume
  void _changeVolume(BuildContext context, DragUpdateDetails details) {
    context
        .read<ChangeSystemVolumeCubit>()
        .change(details: details, context: context);
  }

  ///!------ Change Video Position
  void _changeVideoPosition(BuildContext context, DragUpdateDetails details,
      YoutubeMusicPlayerSuccessState playerState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dragPercent = details.primaryDelta! / screenWidth;
    int seekSeconds =
        (playerState.controller.totalVideoLength.inSeconds * dragPercent)
            .toInt();

    int newSeekPosition =
        playerState.controller.currentVideoPosition.inSeconds + seekSeconds;
    newSeekPosition = newSeekPosition.clamp(
        0, playerState.controller.totalVideoLength.inSeconds);

    playerState.controller.videoSeekTo(Duration(seconds: newSeekPosition));

    context
        .read<YoutubeMusicPlayerCubit>()
        .showCurrentPositionOnHorizontalDragging(state: playerState);
  }

  void nextMusicButtonClicked(
      FetchCurrentPlayingMusicDataToPlayerState fetchState,
      PodPlayerController controller,
      BuildContext context) {
    int index = fetchState.musicIndex;
    if (index < fetchState.youtubeMusicList.length) {
      index++;

      controller.changeVideo(
          playVideoFrom: PlayVideoFrom.youtube(
              fetchState.youtubeMusicList[index].videoId.toString()));
      context
          .read<CurrentlyPlayingMusicDataToPlayerCubit>()
          .sendYouTubeDataToPlayer(
              youtubeList: fetchState.youtubeMusicList, musicIndex: index);
    }
  }

  void backwardButtonClicked(
      FetchCurrentPlayingMusicDataToPlayerState fetchState,
      PodPlayerController controller,
      BuildContext context) {
    int index = fetchState.musicIndex;
    if (index > 0) {
      index--;

      controller.changeVideo(
          playVideoFrom: PlayVideoFrom.youtube(
              fetchState.youtubeMusicList[index].videoId.toString()));
      context
          .read<CurrentlyPlayingMusicDataToPlayerCubit>()
          .sendYouTubeDataToPlayer(
              youtubeList: fetchState.youtubeMusicList, musicIndex: index);
    }
  }

  ///!-------------------  Slider Theme
  SliderThemeData _sliderThemeData() {
    return SliderThemeData(
        activeTickMarkColor: Colors.white,
        activeTrackColor: Colors.white,
        trackHeight: 0.015.sh,
        thumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.withOpacity(0.6));
  }
}
