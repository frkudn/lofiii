import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import '../../../logic/bloc/favorite_button/favorite_button_bloc.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/chnage_system_volume/chnage_system_volume_cubit.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/consts/consts.dart';
import '../../../utils/custom_snackbar.dart';
import '../../../utils/format_duration.dart';
import '../../widgets/player_screen_more_button/player_screen_more_button_widget.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,

        ///!----      Drag Handle    ----///
        title: myCustomDragHandle,
        centerTitle: true,
        actions: const [
          ////?-------------------    More   Button ---------/////
          PlayerScreenMoreButtonWidget(),
        ],
      ),
      extendBodyBehindAppBar: true,

      ///?-----------------    B O D Y ------------------------///
      body: Stack(
        fit: StackFit.expand,
        children: [
          ///!-------          IF LOADING SHOW THIS
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(state.accentColor),
                    state.isDarkMode
                        ? Colors.black
                        : Color(state.accentColor).withBlue(1)
                  ]),
                ),
              );
            },
          ),

          ///?--------------------        Background Blur Image Section   --------------------///
          BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
              FetchCurrentPlayingMusicDataToPlayerState>(
            builder: (context, state) {
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: CachedNetworkImage(
                  imageUrl: state.fullMusicList[state.musicIndex].image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              );
            },
          ),

          ///?-------------------      Cover Image Section    ---------------////
          ///!----------Cached Network Image--------///
          Positioned(
            top: 0.08.sh,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onDoubleTap: () {
                  ///!-------------On Double Tap on Cover Image Pause/Play the Music
                  context
                      .read<MusicPlayerBloc>()
                      .add(MusicPlayerTogglePlayPauseEvent());
                },
                onVerticalDragUpdate: (details) {
                  ///----------!Change System Volume
                  context
                      .read<ChangeSystemVolumeCubit>()
                      .change(details: details, context: context);
                },
                child: BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                    FetchCurrentPlayingMusicDataToPlayerState>(
                  builder: (context, state) {
                    return CachedNetworkImage(
                      ///!--------   Music Image Url List   -------///
                      imageUrl: state.fullMusicList[state.musicIndex].image,

                      ///!-------    On Image Successfully Loaded    ---------///
                      imageBuilder: (context, imageProvider) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.transparent,
                          margin: EdgeInsets.zero,
                          child: Container(
                            height: 0.5.sh,
                            width: 0.8.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ///---!  Error Widget of Cover Image
                      errorWidget: (context, url, error) =>
                          BlocBuilder<ThemeModeCubit, ThemeModeState>(
                        builder: (context, state) {
                          return Center(
                            child: SizedBox(
                              height: 0.5.sh,
                              width: 0.8.sw,
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.music,
                                  size: 45.spMax,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          ///?-----------------------      Player Buttons Section     -------------///
          ///?-----------------------      Glass     -------------///
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 0.05.sh),
              height: 0.28.sh,
              width: 0.8.sw,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                            FetchCurrentPlayingMusicDataToPlayerState>(
                          builder: (context, fetchCurrentPlayingMusicState) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ///!      ---------------Music Title----///
                                Flexible(
                                  child: Text(
                                    fetchCurrentPlayingMusicState
                                        .fullMusicList[
                                            fetchCurrentPlayingMusicState
                                                .musicIndex]
                                        .title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 22.sp, color: Colors.white),
                                  ),
                                ),

                                ///!----------------------       Favorite/Like Button Toggle  --------------///

                                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                                  builder: (context, themeState) {
                                    return BlocBuilder<FavoriteButtonBloc,
                                        FavoriteButtonState>(
                                      builder: (context, state) {
                                        bool isFavorite = state.favoriteList
                                            .contains(fetchCurrentPlayingMusicState
                                                .fullMusicList[
                                                    fetchCurrentPlayingMusicState
                                                        .musicIndex]
                                                .title);
                                        return IconButton(
                                          onPressed: () {
                                            context
                                                .read<FavoriteButtonBloc>()
                                                .add(FavoriteButtonToggleEvent(
                                                    title: fetchCurrentPlayingMusicState
                                                        .fullMusicList[
                                                            fetchCurrentPlayingMusicState
                                                                .musicIndex]
                                                        .title));
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            isFavorite
                                                ? FontAwesomeIcons.heartPulse
                                                : FontAwesomeIcons.heart,
                                            color:
                                            isFavorite
                                                ? Color(themeState.accentColor)
                                                :
                                            Colors.white,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),

                        ///!---------     Artists Names   -------////
                        BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                            FetchCurrentPlayingMusicDataToPlayerState>(
                          builder: (context, state) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.fullMusicList[state.musicIndex].artists
                                    .join(", ")
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white70),
                              ),
                            );
                          },
                        ),

                        ///?--------------------       S L I D E R    ----------------------///
                        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                          builder: (context, state) {
                            if (state is MusicPlayerSuccessState) {
                              return BlocBuilder<ThemeModeCubit,
                                  ThemeModeState>(
                                builder: (context, themeState) {
                                  return StreamBuilder(
                                      stream: state.positionStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return StreamBuilder(
                                              stream: state.audioPlayer
                                                  .bufferedPositionStream,
                                              builder:
                                                  (context, bufferedSnapshot) {
                                                if (bufferedSnapshot.hasData) {
                                                  ///!---------   If Music is Completed
                                                  if (state.audioPlayer
                                                          .processingState ==
                                                      ProcessingState
                                                          .completed) {
                                                    return Slider(
                                                        value: 0,
                                                        min: 0,
                                                        max: 1,
                                                        activeColor: Color(
                                                            themeState
                                                                .accentColor),
                                                        secondaryActiveColor:
                                                            Color(themeState
                                                                    .accentColor)
                                                                .withOpacity(
                                                                    0.6),
                                                        onChanged: (val) {});
                                                  }

                                                  ///!  ------------  If Music is Playing
                                                  else {
                                                    return Slider(
                                                        activeColor: Color(
                                                            themeState
                                                                .accentColor),
                                                        secondaryActiveColor:
                                                            Color(themeState.accentColor)
                                                                .withOpacity(
                                                                    0.6),
                                                        secondaryTrackValue:
                                                            bufferedSnapshot
                                                                    .data
                                                                    ?.inSeconds
                                                                    .toDouble() ??
                                                                0,
                                                        min: 0,
                                                        max: state
                                                                .audioPlayer
                                                                .duration
                                                                ?.inSeconds
                                                                .toDouble() ??
                                                            0.1,
                                                        value: snapshot
                                                                .data?.inSeconds
                                                                .toDouble() ??
                                                            0.1,
                                                        onChanged: (value) {
                                                          context
                                                              .read<
                                                                  MusicPlayerBloc>()
                                                              .add(MusicPlayerSeekEvent(
                                                                  position: value
                                                                      .toInt()));
                                                        });
                                                  }
                                                } else {
                                                  return Slider(
                                                      activeColor: Color(
                                                          themeState
                                                              .accentColor),
                                                      secondaryActiveColor:
                                                          Color(themeState
                                                                  .accentColor)
                                                              .withOpacity(0.6),
                                                      min: 0,
                                                      max:
                                                          state
                                                                  .audioPlayer
                                                                  .duration
                                                                  ?.inSeconds
                                                                  .toDouble() ??
                                                              0.1,
                                                      value: snapshot
                                                              .data?.inSeconds
                                                              .toDouble() ??
                                                          0.1,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                MusicPlayerBloc>()
                                                            .add(MusicPlayerSeekEvent(
                                                                position: value
                                                                    .toInt()));
                                                      });
                                                }
                                              });
                                        } else {
                                          return Slider(
                                              activeColor: Colors.transparent,
                                              value: 0.0,
                                              onChanged: (v) {});
                                        }
                                      });
                                },
                              );
                            } else {
                              return Slider(
                                  activeColor: Colors.transparent,
                                  value: 0.0,
                                  onChanged: (v) {});
                            }
                          },
                        ),

                        ///?-----------------         Music Position & Duration         ------///
                        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                          builder: (context, state) {
                            ///! ----      MusicPlayerSuccessState
                            if (state is MusicPlayerSuccessState) {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14.spMax),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///!----  Position Stream    ----///

                                    StreamBuilder(
                                        stream: state.positionStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            ///?------ Position Stream Text
                                            ///!-------  If Music is Playing
                                            if (state.audioPlayer
                                                    .processingState !=
                                                ProcessingState.completed) {
                                              return Text(
                                                FormatDuration.format(
                                                    snapshot.data),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              );

                                              ///!-------  If Music is Completed
                                            } else {
                                              return const Text(
                                                "00:00",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                          }

                                          ///!-------  If Position snapshot hasn't any data
                                          else {
                                            return const Text(
                                              "00:00",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }
                                        }),

                                    ///-!----    Duration Stream   -----////

                                    ///--! -----   If Music is Playing
                                    if (state.audioPlayer.processingState !=
                                        ProcessingState.completed)
                                      StreamBuilder(
                                          stream: state.durationStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              ///!-------  If Music is Playing
                                              if (state.audioPlayer
                                                      .processingState !=
                                                  ProcessingState.completed) {
                                                return Text(
                                                  FormatDuration.format(
                                                      snapshot.data),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                );
                                              }

                                              ///!-------  If Music is Completed
                                              else {
                                                return const Text(
                                                  "00:00",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              }

                                              ///! -------   If Duration snapshot hasn't any data
                                            } else {
                                              return const Text(
                                                "00:00",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                          }),
                                  ],
                                ),
                              );
                            }

                            ///! ----      MusicPlayerLoadingState  and FailureState
                            else {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 14.spMax),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "00:00",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "00:00",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),

                        SizedBox(
                          height: 0.01.sh,
                        ),

                        ///!-------    Player Buttons      -------///
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.spMax),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Center(
                              child: Row(
                                children: [
                                  ///!----       Shuffle     ----///
                                  BlocBuilder<MusicPlayerBloc,
                                      MusicPlayerState>(
                                    builder: (context, state) {
                                      if (state is MusicPlayerSuccessState) {
                                        return IconButton(
                                            onPressed: () {
                                              context
                                                  .read<MusicPlayerBloc>()
                                                  .add(
                                                      MusicPlayerShuffleEvent());
                                            },
                                            icon: StreamBuilder(
                                                stream: state.audioPlayer
                                                    .shuffleModeEnabledStream,
                                                builder: (context, snapshot) {
                                                  return BlocBuilder<
                                                      ThemeModeCubit,
                                                      ThemeModeState>(
                                                    builder: (context, state) {
                                                      return Icon(
                                                        EvaIcons.shuffle,
                                                        color: snapshot.data ==
                                                                true
                                                            ? Color(state
                                                                .accentColor)
                                                            : Colors.white,
                                                      );
                                                    },
                                                  );
                                                }));
                                      } else {
                                        return const Icon(
                                          EvaIcons.shuffle,
                                          color: Colors.white,
                                        );
                                      }
                                    },
                                  ),

                                  ///!----         Previous   Music Button  ----///
                                  BlocBuilder<
                                      CurrentlyPlayingMusicDataToPlayerCubit,
                                      FetchCurrentPlayingMusicDataToPlayerState>(
                                    builder: (context, state) {
                                      return IconButton(
                                          onPressed: () {
                                            _backwardMusicButtonOnTap(
                                                state, context);
                                          },
                                          icon: const Icon(
                                            EvaIcons.skipBack,
                                            color: Colors.white,
                                          ));
                                    },
                                  ),

                                  ///!---------------        Play & Pause Button       -----------///
                                  BlocBuilder<MusicPlayerBloc,
                                      MusicPlayerState>(
                                    builder: (context, state) {
                                      if (state is MusicPlayerSuccessState) {
                                        return StreamBuilder(
                                            stream: state
                                                .audioPlayer.playerStateStream,
                                            builder:
                                                (context, snapshotPlayerState) {
                                              ///?----                   if Loading, buffering
                                              if (snapshotPlayerState.hasData) {
                                                if (snapshotPlayerState.data!
                                                            .processingState ==
                                                        ProcessingState
                                                            .loading ||
                                                    snapshotPlayerState.data!
                                                            .processingState ==
                                                        ProcessingState
                                                            .buffering) {
                                                  //! --------------           Show Loading Icon        --------------///
                                                  return Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          EvaIcons.playCircle,
                                                          size: 40.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }

                                                ///? -------            If Processing State is Completed
                                                else if (snapshotPlayerState
                                                        .data!
                                                        .processingState ==
                                                    ProcessingState.completed) {
                                                  return Center(
                                                    child: BlocBuilder<
                                                        CurrentlyPlayingMusicDataToPlayerCubit,
                                                        FetchCurrentPlayingMusicDataToPlayerState>(
                                                      builder:
                                                          (context, state) {
                                                        ///!----   If Music is Completed play again by pressing this button
                                                        return IconButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      MusicPlayerBloc>()
                                                                  .add(MusicPlayerInitializeEvent(
                                                                      url: state
                                                                          .fullMusicList[
                                                                              state.musicIndex]
                                                                          .url));
                                                            },
                                                            icon: Icon(
                                                              EvaIcons
                                                                  .playCircle,
                                                              size: 40.sp,
                                                              color:
                                                                  Colors.white,
                                                            ));
                                                      },
                                                    ),
                                                  );
                                                }
                                                //--------!           If Successfully Playing---------///
                                                else {
                                                  return StreamBuilder(
                                                      stream:
                                                          state.playingStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
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
                                                                    ? EvaIcons
                                                                        .pauseCircle
                                                                    : EvaIcons
                                                                        .playCircle,
                                                                color: Colors
                                                                    .white,
                                                                size: 40.sp,
                                                              ));
                                                        } else {
                                                          return const CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeCap:
                                                                StrokeCap.round,
                                                          );
                                                        }
                                                      });
                                                }
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeCap: StrokeCap.round,
                                                );
                                              }

                                              ///-------y
                                            });
                                      } else {
                                        return const CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),

                                  ///!----------------         Next Button Icon     ----------///
                                  BlocBuilder<
                                      CurrentlyPlayingMusicDataToPlayerCubit,
                                      FetchCurrentPlayingMusicDataToPlayerState>(
                                    builder: (context, state) {
                                      return IconButton(
                                          onPressed: () {
                                            _nextMusicButtonOnTap(
                                                state, context);
                                          },
                                          icon: const Icon(
                                            EvaIcons.skipForward,
                                            color: Colors.white,
                                          ));
                                    },
                                  ),

                                  ///!--------------   Repeat Button
                                  IconButton(
                                    onPressed: () {
                                      MyCustomSnackbars.showSimpleSnackbar(
                                          context,
                                          message:
                                              "Repeat button will be fixed in next upcoming stable version");
                                    },
                                    icon: const Icon(
                                      EvaIcons.repeat,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///-------------------?             M E T H O D S    ----------------------------///
  void _nextMusicButtonOnTap(
      FetchCurrentPlayingMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index < state.fullMusicList.length) {
      index++;
      context
          .read<MusicPlayerBloc>()
          .add(MusicPlayerInitializeEvent(url: state.fullMusicList[index].url));
      context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index, fullMusicList: state.fullMusicList);
    }
  }

  void _backwardMusicButtonOnTap(
      FetchCurrentPlayingMusicDataToPlayerState state, BuildContext context) {
    int index = state.musicIndex;
    if (index > 0) {
      index--;
      context
          .read<MusicPlayerBloc>()
          .add(MusicPlayerInitializeEvent(url: state.fullMusicList[index].url));
      context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index, fullMusicList: state.fullMusicList);
    }
  }
}
