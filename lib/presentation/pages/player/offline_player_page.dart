import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/searchable_list_scroll_controller/download_scroll_controller_state.dart';
import 'package:lofiii/logic/cubit/searchable_list_scroll_controller/searchableList_scroll_controller_cubit.dart';
import 'package:one_context/one_context.dart';

import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/chnage_system_volume/chnage_system_volume_cubit.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/consts/consts.dart';
import '../../../utils/format_duration.dart';
import '../../widgets/offline_player_background_gradient_boxes/offline_player_background_gradient_boxes_widget.dart';

class OfflinePlayerPage extends StatefulWidget {
  const OfflinePlayerPage({
    super.key,
  });

  @override
  State<OfflinePlayerPage> createState() => _OfflinePlayerPageState();
}

class _OfflinePlayerPageState extends State<OfflinePlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: ElasticInRight(
          child: IconButton(
              onPressed: () {
                OneContext().pop();
              },
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.white,
                size: 30.sp,
              )),
        ),

        automaticallyImplyLeading: false,

        ///!-----      Drag Handle    ----///
        title: SlideInUp(child: myCustomDragHandle),
        centerTitle: true,
        toolbarHeight: 0.15.sh,
      ),
      extendBodyBehindAppBar: true,
      body:
          // return
          BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state is MusicPlayerSuccessState) {
            return BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, themeState) {
                return BlocBuilder<NowPlayingOfflineMusicDataToPlayerCubit,
                    NowPlayingOfflineMusicDataToPlayerState>(
                  builder: (context, nowPlayingMusicState) {
                    return Stack(
                      children: [
                        //!------------------------------------------------------------------------------------------///
                        ///?--------------------        Background Gradient Colors Section   --------------------///
                        ///------------------------------------------------------------------------------------------///
                        ///---  Back
                        const OfflinePlayerBackgroundGradientBoxesWidget(),

                        ///--------------------------------------------------------------------------///
                        ///!------------------------  Volume & Play Pause Gesture  ----------------///
                        ///--------------------------------------------------------------------------///
                        Positioned(
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
                        ),

                        ///!---------   -----------------///

                        ///!------- Music Icon -----///
                        ZoomIn(
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.music,
                              color: Colors.white,
                              size: 50.spMax,
                            ),
                          ),
                        ),

                        ///!-------------  Glass Gradient Box ---------///
                        Positioned(
                          bottom: 0.05.sh,
                          width: 1.sw,
                          child: SlideInUp(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.05.sw,
                                vertical: 0.02.sh,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 0.04.sw),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///!      ---------------Music Title  & Artist----///
                                  SlideInRight(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nowPlayingMusicState.musicTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 29.sp,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          nowPlayingMusicState.musicArtist,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///!------------------   Slider & Buttons
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ////!---------------  Slider ----------////
                                      ElasticInRight(
                                        child: StreamBuilder(
                                            stream: state
                                                .combinedStreamPositionAndDurationAndBufferedList,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                      snapshot.connectionState ==
                                                          ConnectionState
                                                              .done ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.active) {
                                                final positionSnapshot =
                                                    snapshot.data?.first;
                                                final durationSnapshot =
                                                    snapshot.data?[1];
                                                final bufferedPositionSnapshot =
                                                    snapshot.data?.last;

                                                return SliderTheme(
                                                  data: SliderThemeData(
                                                      trackHeight: 0.01.sh,
                                                      inactiveTrackColor:
                                                          Colors.white54),
                                                  child: Slider(
                                                      activeColor: Colors.white,
                                                      secondaryActiveColor:
                                                          Colors.white
                                                              .withOpacity(0.5),
                                                      secondaryTrackValue:
                                                          bufferedPositionSnapshot!
                                                                  .inSeconds
                                                                  .toDouble(),
                                                      min: 0,
                                                      max: durationSnapshot!
                                                          .inSeconds
                                                          .toDouble(),
                                                      value: positionSnapshot!
                                                              .inSeconds
                                                              .toDouble(),
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                MusicPlayerBloc>()
                                                            .add(MusicPlayerSeekEvent(
                                                                position: value
                                                                    .toInt()));
                                                      }),
                                                );
                                              } else {
                                                return Slider(
                                                    activeColor:
                                                        Colors.transparent,
                                                    value: 0.0,
                                                    max: 1,
                                                    min: 0,
                                                    onChanged: (v) {});
                                              }
                                            }),
                                      ),

                                      ////!---------------    Position   -----///
                                      BlocBuilder<MusicPlayerBloc,
                                          MusicPlayerState>(
                                        builder: (context, state) {
                                          ///! ----      MusicPlayerSuccessState
                                          if (state
                                              is MusicPlayerSuccessState) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14.spMax),
                                              child: StreamBuilder(
                                                  stream: state
                                                      .combinedStreamPositionAndDurationAndBufferedList,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                            snapshot.connectionState ==
                                                                ConnectionState
                                                                    .active ||
                                                        snapshot.connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                      final positionSnapshot =
                                                          snapshot.data!.first;
                                                      final durationSnapshot =
                                                          snapshot.data![1];

                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ///!----  Position    ----///
                                                          Text(
                                                            FormatDuration.format(
                                                                positionSnapshot),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),

                                                          ///-!----    Duration Stream   -----////
                                                          Text(
                                                            FormatDuration.format(
                                                                durationSnapshot),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ///!----  Position    ----///
                                                          Text(
                                                            "00:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),

                                                          ///-!----    Duration Stream   -----////
                                                          Text(
                                                            "00:00",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14.spMax),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                      ),

                                      ///-------------------------------------------------------------///
                                      ///!---------------------------    Player Buttons      -------///
                                      ///?------------------------------------------------------------------///
                                      JelloIn(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ///---------------------------------------------------///
                                            ///!----      Previous   Music Button  ----///

                                            BlocBuilder<
                                                SearchableListScrollControllerCubit,
                                                SearchableListScrollControllerState>(
                                              builder: (context, state) {
                                                return IconButton(
                                                    onPressed: () {
                                                      _backwardMusicButtonOnTap(
                                                          nowPlayingMusicState,
                                                          context);

                                                      if(state.scrollOffset != 0) {
                                                        ///!------- Current Playing music scroll position
                                                        context
                                                            .read<
                                                            SearchableListScrollControllerCubit>()
                                                            .updateScrollOffset(
                                                            scrollOffset:
                                                            state.scrollOffset -
                                                                70.sp);
                                                      }
                                                    },
                                                    icon: Icon(
                                                      EvaIcons.skipBack,
                                                      size: 35.sp,
                                                      color: Colors.white,
                                                    ));
                                              },
                                            ),

                                            ///---------------------------------------------------///
                                            ///!----  Replay Button
                                            IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<MusicPlayerBloc>()
                                                      .add(
                                                          MusicPlayerBackwardEvent());
                                                },
                                                icon: Icon(
                                                  Icons.replay_5_outlined,
                                                  color: Colors.white,
                                                  size: 40.sp,
                                                )),

                                            ///!---------------        Play & Pause Button       -----------///
                                            BlocBuilder<MusicPlayerBloc,
                                                MusicPlayerState>(
                                              builder: (context, state) {
                                                if (state
                                                    is MusicPlayerSuccessState) {
                                                  return StreamBuilder(
                                                      stream: state.audioPlayer
                                                          .playerStateStream,
                                                      builder: (context,
                                                          snapshotPlayerState) {
                                                        ///?----                   if Loading, buffering
                                                        if (snapshotPlayerState
                                                            .hasData) {
                                                          if (snapshotPlayerState
                                                                      .data!
                                                                      .processingState ==
                                                                  ProcessingState
                                                                      .loading ||
                                                              snapshotPlayerState
                                                                      .data!
                                                                      .processingState ==
                                                                  ProcessingState
                                                                      .buffering) {
                                                            //! --------------           Show Loading Icon        --------------///
                                                            return IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                EvaIcons
                                                                    .playCircle,
                                                                size: 45.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          }

                                                          ///? -------            If Processing State is Completed
                                                          else if (snapshotPlayerState
                                                                  .data!
                                                                  .processingState ==
                                                              ProcessingState
                                                                  .completed) {
                                                            return BlocBuilder<
                                                                CurrentlyPlayingMusicDataToPlayerCubit,
                                                                FetchCurrentPlayingMusicDataToPlayerState>(
                                                              builder: (context,
                                                                  state) {
                                                                ///---------------------------------------------------///
                                                                ///!----   If Music is Completed play again by pressing this button
                                                                return IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .read<
                                                                              MusicPlayerBloc>()
                                                                          .add(MusicPlayerInitializeEvent(
                                                                              url: nowPlayingMusicState.snapshotMusicList![nowPlayingMusicState.musicIndex].uri.toString()));
                                                                    },
                                                                    icon: Icon(
                                                                      EvaIcons
                                                                          .playCircle,
                                                                      size:
                                                                          45.sp,
                                                                      color: Colors
                                                                          .white,
                                                                    ));
                                                              },
                                                            );
                                                          }
                                                          //--------!           If Successfully Playing---------///
                                                          else {
                                                            return StreamBuilder(
                                                                stream: state
                                                                    .playingStream,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  return IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .read<MusicPlayerBloc>()
                                                                            .add(MusicPlayerTogglePlayPauseEvent());
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        snapshot.data ==
                                                                                true
                                                                            ? EvaIcons.pauseCircle
                                                                            : EvaIcons.playCircle,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 45
                                                                            .sp,
                                                                      ));
                                                                });
                                                          }
                                                        } else {
                                                          return const CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeCap:
                                                                StrokeCap.round,
                                                          );
                                                        }

                                                        ///-------y
                                                      });
                                                } else {
                                                  return const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),

                                            ///---------------------------------------------------///
                                            ///!----   Forward Button

                                            IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<MusicPlayerBloc>()
                                                      .add(
                                                          MusicPlayerForwardEvent());
                                                },
                                                icon: Icon(
                                                  Icons.forward_5_outlined,
                                                  color: Colors.white,
                                                  size: 40.sp,
                                                )),

                                            ///---------------------------------------------------///
                                            ///!--------------      Next   Music Button  ----///
                                            BlocBuilder<
                                                SearchableListScrollControllerCubit,
                                                SearchableListScrollControllerState>(
                                              builder: (context, state) {
                                                return IconButton(
                                                    onPressed: () {
                                                      _nextMusicButtonOnTap(
                                                          nowPlayingMusicState,
                                                          context);

                                                      ///!------- Current Playing music scroll position
                                                      context
                                                          .read<
                                                              SearchableListScrollControllerCubit>()
                                                          .updateScrollOffset(
                                                              scrollOffset:
                                                                  state.scrollOffset +
                                                                      70.sp);
                                                    },
                                                    icon: Icon(
                                                      EvaIcons.skipForward,
                                                      color: Colors.white,
                                                      size: 35.sp,
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          } else {
            return Slider(
                activeColor: Colors.transparent, value: 0.0, onChanged: (v) {});
          }
        },
      ),
    );
  }

  ///--------------------------------------------------------------------------------///
  ///-------------------?             M E T H O D S    ----------------------------///
  ///!--------------------------------------------------------------------------------///
  void _nextMusicButtonOnTap(
      NowPlayingOfflineMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index < state.musicListLength) {
      index++;

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: state.snapshotMusicList![index].uri.toString()));

      ///---- Also Change Music Title and Artist on Next Button Clicked
      context.read<NowPlayingOfflineMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            futureMusicList: state.futureMusicList,
            musicTitle: state.snapshotMusicList![index].title,
            musicArtist: state.snapshotMusicList![index].artist,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);
    }
  }

  void _backwardMusicButtonOnTap(
      NowPlayingOfflineMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index > 0) {
      index--;

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: state.snapshotMusicList![index].uri.toString()));

      ///---- Also Change Music Title and Artist on Back Button Clicked
      context.read<NowPlayingOfflineMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            futureMusicList: state.futureMusicList,
            musicTitle: state.snapshotMusicList![index].title,
            musicArtist: state.snapshotMusicList![index].artist,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);
    }
  }
}
