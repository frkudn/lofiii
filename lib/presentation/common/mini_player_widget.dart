// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lofiii/base/router/app_routes.dart';
import 'package:lofiii/logic/cubit/now_playing_music_data_to_player/now_playing_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import 'package:lofiii/presentation/pages/player/offline/ui/offline_player_page.dart';
import '../../logic/bloc/player/music_player_bloc.dart';
import '../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../pages/player/online/ui/online_player_page.dart';

class MiniPlayerPageWidget extends StatefulWidget {
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
  State<MiniPlayerPageWidget> createState() => _MiniPlayerPageWidgetState();
}

class _MiniPlayerPageWidgetState extends State<MiniPlayerPageWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, musicDataState) {
        return BlocBuilder<ShowMiniPlayerCubit, ShowMiniPlayerState>(
          builder: (context, showMiniPlayerState) {
            return Align(
              alignment: widget.playerAlignment ?? Alignment.bottomCenter,
              child: Card(
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.borderRadiusTopLeft ?? 50),
                    topRight:
                        Radius.circular(widget.borderRadiusTopRight ?? 50),
                  ),
                ),
                child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
                  builder: (context, themeState) {
                    return GestureDetector(
                      ///---------------! Mini Player On Tap
                      onTap: () {
                        _miniPlayerOnTap(showMiniPlayerState, context);
                      },

                      ///----------!
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: widget.bottomMargin ?? 0.06.sh),
                        height: widget.playerHeight ?? 0.1.sh,
                        width: widget.playerWidth ?? 0.85.sw,
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
                            topLeft: Radius.circular(
                                widget.borderRadiusTopLeft ?? 50),
                            topRight: Radius.circular(
                                widget.borderRadiusTopRight ?? 50),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: widget.paddingBottom ?? 0.03.sh,
                              left: widget.paddingLeft ?? 0.05.sw,
                              right: widget.paddingRight ?? 0,
                              top: widget.paddingTop ?? 0),

                          ///------------------?  M A I N  R O W
                          child: Builder(builder: (context) {
                            if (showMiniPlayerState.isYouTubeMusic == false) {
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ///!--------------------  MUSIC IMAGE
                                  if (showMiniPlayerState.isOnlineMusic)
                                    CachedNetworkImage(
                                      imageUrl: musicDataState.musicThumbnail
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>

                                          ///---- Animation
                                          Spin(
                                        infinite: true,
                                        duration: const Duration(seconds: 15),
                                        child: CircleAvatar(
                                          backgroundImage: imageProvider,
                                          radius: 19.spMax,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 19.spMax,
                                        child: Icon(
                                          FontAwesomeIcons.music,
                                          size: 12.spMax,
                                          color: Color(themeState.accentColor),
                                        ),
                                      ),
                                    ),

                                  ///!--------------------  Offline Music Image
                                  if (showMiniPlayerState.isOnlineMusic ==
                                      false)
                                    BlocBuilder<
                                        NowPlayingMusicDataToPlayerCubit,
                                        NowPlayingMusicDataToPlayerState>(
                                      builder: (context, nowPlayingState) {
                                       Uint8List? musicThumbnail = nowPlayingState
                                                      .musicThumbnail;
                                        return Spin(
                                          infinite: true,
                                          duration: const Duration(seconds: 4),
                                          child: musicThumbnail ==
                                                  null
                                              ? CircleAvatar(
                                                  backgroundColor: Color(
                                                      themeState.accentColor),
                                                  radius: 19.spMax,
                                                  child: Icon(
                                                    FontAwesomeIcons.music,
                                                    size: 12.spMax,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: MemoryImage(
                                                      musicThumbnail),
                                                ),
                                        );
                                      },
                                    ),

                                  SizedBox(
                                    width: 0.02.sw,
                                  ),

                                  ///!---------------  Music Title & Artists
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ///---------! Online Music Title
                                        if (showMiniPlayerState.isOnlineMusic)
                                          Text(
                                            musicDataState.musicTitle
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),

                                        if (showMiniPlayerState.isOnlineMusic ==
                                            false)
                                          BlocBuilder<
                                              NowPlayingMusicDataToPlayerCubit,
                                              NowPlayingMusicDataToPlayerState>(
                                            builder: (context, nowPlayState) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ///---------! Offline Music Title
                                                  Text(
                                                    nowPlayState.musicTitle.toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),

                                                  ///-----! Offline Music Artists
                                                  Text(
                                                    nowPlayState.musicArtist
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 9),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),

                                        ///-----! Online Music Artists
                                        if (showMiniPlayerState.isOnlineMusic)
                                          Text(
                                            musicDataState.musicArtist
                                                .join(', ')
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
                                  BlocBuilder<NowPlayingMusicDataToPlayerCubit,
                                      NowPlayingMusicDataToPlayerState>(
                                    builder: (context, nowPlayingMusicState) {
                                      return Flexible(
                                        child: BlocBuilder<ThemeModeCubit,
                                            ThemeModeState>(
                                          builder: (context, themeState) {
                                            return BlocBuilder<MusicPlayerBloc,
                                                MusicPlayerState>(
                                              builder: (context, state) {
                                                if (state
                                                    is MusicPlayerSuccessState) {
                                                  return BlocBuilder<
                                                      NowPlayingMusicDataToPlayerCubit,
                                                      NowPlayingMusicDataToPlayerState>(
                                                    builder: (context,
                                                        fetchCurrentMusicState) {
                                                      return StreamBuilder(
                                                          stream: state
                                                              .audioPlayer
                                                              .playerStateStream,
                                                          builder: (context,
                                                              playerStateSnapshot) {
                                                            if (playerStateSnapshot
                                                                .hasData) {
                                                              ///!---  if Music Playing is Completed shows then show stop button
                                                              if (playerStateSnapshot
                                                                      .data!
                                                                      .processingState ==
                                                                  ProcessingState
                                                                      .completed) {
                                                                //-------- Play next music automatically if available
                                                                _playNextMusicIfAvailable(
                                                                    context,
                                                                    nowPlayingMusicState);

                                                                return SizedBox(
                                                                  width: 0.1.sw,
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
                                                                    radius:
                                                                        12.sp,
                                                                    backgroundColor:
                                                                        Color(themeState
                                                                            .accentColor),
                                                                    child:
                                                                        const CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  );
                                                                }

                                                                ///! ---------- If music isn't loading
                                                                else {
                                                                  return StreamBuilder(
                                                                    stream: state
                                                                        .playingStream,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            context.read<MusicPlayerBloc>().add(MusicPlayerTogglePlayPauseEvent());
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            snapshot.data == true
                                                                                ? FontAwesomeIcons.circlePause
                                                                                : FontAwesomeIcons.circlePlay,
                                                                            size:
                                                                                30.spMax,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Icon(
                                                                          EvaIcons
                                                                              .pauseCircle,
                                                                          size:
                                                                              30.spMax,
                                                                          color:
                                                                              Colors.white,
                                                                        );
                                                                      }
                                                                    },
                                                                  );
                                                                }
                                                              }
                                                            }

                                                            ///!----- If PlayerState snapshot hasn't any Data
                                                            else {
                                                              return CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                backgroundColor:
                                                                    Color(themeState
                                                                        .accentColor),
                                                              );
                                                            }
                                                          });
                                                    },
                                                  );
                                                }

                                                ///! ------ if MusicPlayer state isn't success state
                                                else {
                                                  return CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        backgroundColor: Color(
                                                            themeState
                                                                .accentColor),
                                                      ));
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 0.05.sw,
                                  )
                                ],
                              );
                            }

                            ///?-----------------------------------------------------------------------//
                            ///!---------------------- If Youtube Music ----------------------------///
                            ///----------------------------------------------------------------------///
                            else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  children: [
                                    ///!-------- Video Player
                                    // BlocBuilder<YoutubeMusicPlayerCubit,
                                    //     YoutubeMusicPlayerState>(
                                    //   builder: (context, ytState) {
                                    //     if(ytState is YoutubeMusicPlayerSuccessState){
                                    //       return Padding(
                                    //         padding: const EdgeInsets.symmetric(vertical: 8),
                                    //         child: ClipRRect(
                                    //           borderRadius: BorderRadius.circular(20),
                                    //           child: const MyYouTubeVideoPlayerWidget(),
                                    //         ),
                                    //       );
                                    //     }

                                    ///!-------- Thumbnail
                                    // else {
                                    //   return
                                    CachedNetworkImage(
                                      imageUrl: musicDataState.musicThumbnail,
                                      imageBuilder: (context, imageProvider) =>

                                          ///!---- Animation
                                          SpinPerfect(
                                        infinite: true,
                                        duration: const Duration(seconds: 15),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          onBackgroundImageError:
                                              (exception, stackTrace) =>
                                                  const Icon(Icons.music_note),
                                          backgroundImage: imageProvider,
                                          radius: 19.spMax,
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        radius: 19.spMax,
                                        child: Icon(
                                          FontAwesomeIcons.video,
                                          size: 12.spMax,
                                          color: Color(themeState.accentColor),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 19.spMax,
                                        child: Icon(
                                          FontAwesomeIcons.music,
                                          size: 12.spMax,
                                          color: Color(themeState.accentColor),
                                        ),
                                      ),
                                    ),
                                    //     }
                                    //   },
                                    // ),
                                    const Gap(5),

                                    ///!------ Title & Artist
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ///---------!  Music Title
                                          Text(
                                            musicDataState.musicTitle
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),

                                          ///-----!  Music Artists
                                          Text(
                                            musicDataState.musicArtist
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                fontFamily: "Poppins"),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Gap(5),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  ///?-------------------------------------------------------------------///
  ///!--------------------------------   M E T H O D S -----------------///
  ///-------------------------------------------------------------------///
  _miniPlayerOnTap(showMiniPlayerState, context) async {
    if (showMiniPlayerState.isYouTubeMusic) {
      ///----- Hide Status Bar Values
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []);

      ///!-----Show Player Screen ----///
      Navigator.pushNamed(context, AppRoutes.youtubeMusicPlayerRoute);
    } else {
      if (showMiniPlayerState.isOnlineMusic) {
        //?-----Show Online Player Screen-----///
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => const OnlinePlayerPage(),
        );
      } else {
        //?-----Show offline Player Screen-----///
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => const OfflinePlayerPage(),
        );
      }
    }
  }

  ///--------------------------------------------------------------------------------///
  ///-------------------?             Offline Player Methods    ----------------------------///
  ///!--------------------------------------------------------------------------------///
  void _nextMusicButtonOnTap(
      NowPlayingMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index < state.musicListLength) {
      index++;
      final music = state.musicList[index];

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.uri,
          isOnlineMusic: false,
          musicAlbum: music.album ?? "Unknown",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: null,
          offlineMusicThumbnail: music.artwork));

      ///---- Also Change Music Title and Artist on Next Button Clicked
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            musicList: state.musicList,
            musicThumbnail: state.musicList[index].artwork,
            musicTitle: state.musicList[index].title,
            musicArtist: state.musicList[index].artist,
            uri: state.musicList[index].uri,
            musicId: state.musicList[index].id,
            musicListLength: state.musicList.length,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);
    }
  }

  void _backwardMusicButtonOnTap(
      NowPlayingMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index > 0) {
      index--;
      final music = state.musicList[index];

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.uri.toString(),
          isOnlineMusic: false,
          musicAlbum: music.album ?? "Unknown",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: null,
          offlineMusicThumbnail: music.artwork));

      ///---- Also Change Music Title and Artist on Back Button Clicked
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            musicList: state.musicList,
            musicThumbnail: state.musicList[index].artwork,
            musicTitle: state.musicList[index].title,
            musicArtist: state.musicList[index].artist,
            uri: state.musicList[index].uri,
            musicListLength: state.musicList.length,
            musicId: state.musicList[index].id,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);
    }
  }

  _playNextMusicIfAvailable(BuildContext context,
      NowPlayingMusicDataToPlayerState nowPlayingMusicState) {
    if (nowPlayingMusicState.musicIndex <
        nowPlayingMusicState.musicList.length - 1) {
      _nextMusicButtonOnTap(nowPlayingMusicState, context);
    }
  }
}
