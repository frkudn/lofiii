// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../pages/player/player_page.dart';

class MiniPlayerPageWidget extends StatelessWidget {
  const MiniPlayerPageWidget(
      {super.key,
      this.playerHeight,
      this.playerWidth,
      this.playerAlignment,
      this.paddingTop,
      this.paddingBottom,
      this.paddingLeft,
      this.paddingRight,
      this.bottomMargin,
      this.borderRadiusTopLeft,
      this.borderRadiusTopRight});

  final playerHeight;
  final playerWidth;
  final playerAlignment;
  final paddingTop;
  final paddingBottom;
  final paddingLeft;
  final paddingRight;
  final bottomMargin;
  final borderRadiusTopLeft;
  final borderRadiusTopRight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
        FetchCurrentPlayingMusicDataToPlayerState>(
      builder: (context, musicDataState) {
        return Align(
          alignment: playerAlignment ?? Alignment.bottomCenter,
          child: Card(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusTopLeft ?? 50),
                topRight: Radius.circular(borderRadiusTopRight ?? 50),
              ),
            ),
            child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, themeState) {
                return GestureDetector(
                  ///---------------! Mini Player On Tap
                  onTap: () {
                    //?-----Show Player Screen-----///
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      useRootNavigator: true,
                      builder: (context) => const PlayerPage(),
                    );
                  },

                  ///----------!
                  child: Container(
                    margin: EdgeInsets.only(bottom: bottomMargin ?? 0.06.sh),
                    height: playerHeight ?? 0.1.sh,
                    width: playerWidth ?? 0.8.sw,
                    decoration: BoxDecoration(
                      gradient: themeState.isDarkMode
                          ? LinearGradient(colors: [
                              Colors.black38,
                              Color(themeState.accentColor),
                            ])
                          : LinearGradient(colors: [
                              Colors.white,
                              Color(themeState.accentColor),
                            ]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadiusTopLeft ?? 50),
                        topRight: Radius.circular(borderRadiusTopRight ?? 50),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: paddingBottom ?? 0.03.sh,
                          left: paddingLeft ?? 0.05.sw,
                          right: paddingRight ?? 0,
                          top: paddingTop ?? 0),

                      ///------------------?  M A I N  R O W
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///!--------------------  MUSIC IMAGE
                          CachedNetworkImage(
                            imageUrl: musicDataState
                                .fullMusicList[musicDataState.musicIndex].image,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 19.spMax,
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 19.spMax,
                              child: Icon(
                                FontAwesomeIcons.music,
                                size: 12.spMax,
                                color: Color(themeState.accentColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.02.sw,
                          ),

                          ///!---------------  Music Title & Artists
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///---------! Music Title
                                Text(
                                  musicDataState
                                      .fullMusicList[musicDataState.musicIndex]
                                      .title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                ///-----! Music Artists
                                Text(
                                  musicDataState
                                      .fullMusicList[musicDataState.musicIndex]
                                      .artists
                                      .join(", ")
                                      .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),

                          //!/////////////////////////////////////
                          ///---------------?   Buttons //////////
                          Flexible(
                            child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
                              builder: (context, themeState) {
                                return BlocBuilder<MusicPlayerBloc,
                                    MusicPlayerState>(
                                  builder: (context, state) {
                                    if (state is MusicPlayerSuccessState) {
                                      return BlocBuilder<
                                          CurrentlyPlayingMusicDataToPlayerCubit,
                                          FetchCurrentPlayingMusicDataToPlayerState>(
                                        builder:
                                            (context, fetchCurrentMusicState) {
                                          return StreamBuilder(
                                              stream: state.audioPlayer
                                                  .playerStateStream,
                                              builder: (context,
                                                  playerStateSnapshot) {
                                                if (playerStateSnapshot
                                                    .hasData) {
                                                  ///!---  if Music Playing is Completed shows then show stop button
                                                  if (playerStateSnapshot.data!
                                                          .processingState ==
                                                      ProcessingState
                                                          .completed) {
                                                    return IconButton(
                                                      onPressed: () {
                                                        ///--- Play Current Music Again
                                                        context
                                                            .read<
                                                                MusicPlayerBloc>()
                                                            .add(MusicPlayerInitializeEvent(
                                                                url: fetchCurrentMusicState
                                                                    .fullMusicList[
                                                                        fetchCurrentMusicState
                                                                            .musicIndex]
                                                                    .url));
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .circlePause,
                                                        size: 30.spMax,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }

                                                  ///!-----  If Music is not Completed
                                                  else {
                                                    ///!------------- If Music is Loading
                                                    if (playerStateSnapshot
                                                                .data!
                                                                .processingState ==
                                                            ProcessingState
                                                                .loading ||
                                                        playerStateSnapshot
                                                                .data!
                                                                .processingState ==
                                                            ProcessingState
                                                                .buffering) {
                                                      return CircleAvatar(
                                                        radius: 12.sp,
                                                        backgroundColor: Color(
                                                            themeState
                                                                .accentColor),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    }

                                                    ///! ---------- If music isn't loading
                                                    else {
                                                      return StreamBuilder(
                                                          stream: state
                                                              .playingStream,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return IconButton(
                                                                onPressed: () {
                                                                  context
                                                                      .read<
                                                                          MusicPlayerBloc>()
                                                                      .add(
                                                                          MusicPlayerTogglePlayPauseEvent());
                                                                },
                                                                icon: Icon(
                                                                  snapshot.data ==
                                                                          true
                                                                      ? FontAwesomeIcons
                                                                          .circlePause
                                                                      : FontAwesomeIcons
                                                                          .circlePlay,
                                                                  size:
                                                                      30.spMax,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              );
                                                            } else {
                                                              return Icon(
                                                                EvaIcons
                                                                    .pauseCircle,
                                                                size: 30.spMax,
                                                                color: Colors
                                                                    .white,
                                                              );
                                                            }
                                                          });
                                                    }
                                                  }
                                                }

                                                ///!----- If PlayerState snapshot hasn't any Data
                                                else {
                                                  return CircularProgressIndicator(
                                                    color: Colors.white,
                                                    backgroundColor: Color(
                                                        themeState.accentColor),
                                                  );
                                                }
                                              });
                                        },
                                      );
                                    }

                                    ///! ------ if MusicPlayer state isn't success state
                                    else {
                                      return CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor:
                                                Color(themeState.accentColor),
                                          ));
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 0.05.sw,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
