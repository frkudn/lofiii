import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';

class LocalMusicPlayerButtonsWidget extends StatelessWidget {
  const LocalMusicPlayerButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
        NowPlayingMusicDataToPlayerState>(
      builder: (context, nowPlayingMusicState) {
        return JelloIn(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///---------------------------------------------------///
              ///!----      Previous   Music Button  ----///

              BlocBuilder<SearchableListScrollControllerCubit,
                  SearchableListScrollControllerState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      _backwardMusicButtonOnTap(nowPlayingMusicState, context);

                      if (state.scrollOffset != 0) {
                        ///!------- Current Playing music scroll position
                        context
                            .read<SearchableListScrollControllerCubit>()
                            .updateScrollOffset(
                                scrollOffset: state.scrollOffset - 70.sp);
                      }
                    },
                    icon: Icon(
                      EvaIcons.skipBack,
                      size: 35.sp,
                      color: Colors.white,
                    ),
                  );
                },
              ),

              ///---------------------------------------------------///
              ///!----  Replay Button
              IconButton(
                  onPressed: () {
                    context
                        .read<MusicPlayerBloc>()
                        .add(MusicPlayerBackwardEvent());
                  },
                  icon: Icon(
                    Icons.replay_5_outlined,
                    color: Colors.white,
                    size: 40.sp,
                  )),

              ///!---------------        Play & Pause Button       -----------///
              BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
                builder: (context, state) {
                  if (state is MusicPlayerSuccessState) {
                    return StreamBuilder(
                      stream: state.audioPlayer.playerStateStream,
                      builder: (context, snapshotPlayerState) {
                        ///?----                   if Loading, buffering
                        if (snapshotPlayerState.hasData) {
                          if (snapshotPlayerState.data!.processingState ==
                                  ProcessingState.loading ||
                              snapshotPlayerState.data!.processingState ==
                                  ProcessingState.buffering) {
                            //! --------------           Show Loading Icon        --------------///
                            return IconButton(
                              onPressed: () {},
                              icon: Icon(
                                EvaIcons.playCircle,
                                size: 45.sp,
                                color: Colors.white,
                              ),
                            );
                          }

                          ///? -------            If Processing State is Completed
                          else if (snapshotPlayerState.data!.processingState ==
                              ProcessingState.completed) {
                            return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
                                NowPlayingMusicDataToPlayerState>(
                              builder: (context, state) {
                                ///!----   If Music is Completed play next Music

                                _playNextMusicIfAvailable(
                                    context, nowPlayingMusicState);

                                ///---------------------------------------------------///
                                ///!----   If Music is Completed play again by pressing this button
                                return IconButton(
                                  onPressed: () {
                                    final music = nowPlayingMusicState;
                                    context.read<MusicPlayerBloc>().add(
                                        MusicPlayerInitializeEvent(
                                            url: music.uri.toString(),
                                            isOnlineMusic: false,
                                            musicAlbum: music
                                                    .musicList[music.musicIndex]
                                                    .album ??
                                                "Unknown",
                                            musicId: music.musicId,
                                            musicTitle: music.musicTitle,
                                            onlineMusicThumbnail: null,
                                            offlineMusicThumbnail:
                                                music.musicThumbnail));
                                  },
                                  icon: Icon(
                                    EvaIcons.playCircle,
                                    size: 45.sp,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            );
                          }
                          //--------!           If Successfully Playing---------///
                          else {
                            return StreamBuilder(
                              stream: state.playingStream,
                              builder: (context, snapshot) {
                                return IconButton(
                                    onPressed: () {
                                      context.read<MusicPlayerBloc>().add(
                                          MusicPlayerTogglePlayPauseEvent());
                                    },
                                    icon: Icon(
                                      snapshot.data == true
                                          ? EvaIcons.pauseCircle
                                          : EvaIcons.playCircle,
                                      color: Colors.white,
                                      size: 45.sp,
                                    ));
                              },
                            );
                          }
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                          );
                        }

                        ///-------y
                      },
                    );
                  } else {
                    return const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: CircularProgressIndicator());
                  }
                },
              ),

              ///---------------------------------------------------///
              ///!----   Forward Button

              IconButton(
                onPressed: () {
                  context
                      .read<MusicPlayerBloc>()
                      .add(MusicPlayerForwardEvent());
                },
                icon: Icon(
                  Icons.forward_5_outlined,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),

              ///---------------------------------------------------///
              ///!--------------      Next   Music Button  ----///
              BlocBuilder<SearchableListScrollControllerCubit,
                  SearchableListScrollControllerState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      _nextMusicButtonOnTap(nowPlayingMusicState, context);

                      ///!------- Current Playing music scroll position
                      context
                          .read<SearchableListScrollControllerCubit>()
                          .updateScrollOffset(
                              scrollOffset: state.scrollOffset + 70.sp);
                    },
                    icon: Icon(
                      EvaIcons.skipForward,
                      color: Colors.white,
                      size: 35.sp,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ///--------------------------------------------------------------------------------///
  ///-------------------?             M E T H O D S    ----------------------------///
  ///!--------------------------------------------------------------------------------///
  void _nextMusicButtonOnTap(
      NowPlayingMusicDataToPlayerState state, BuildContext context) {
    context.read<MusicPlayerBloc>().add(
        MusicPlayerOfflineNextMusicEvent(nowPlayingState: state,context: context));

  }

  void _backwardMusicButtonOnTap(
      NowPlayingMusicDataToPlayerState state, BuildContext context) {
    context.read<MusicPlayerBloc>().add(MusicPlayerOfflinePreviousMusicEvent(
        nowPlayingState: state, context: context));
  }

  _playNextMusicIfAvailable(BuildContext context,
      NowPlayingMusicDataToPlayerState nowPlayingMusicState) {
    if (nowPlayingMusicState.musicIndex <
        nowPlayingMusicState.musicList.length - 1) {
      _nextMusicButtonOnTap(nowPlayingMusicState, context);
    }
  }
}
