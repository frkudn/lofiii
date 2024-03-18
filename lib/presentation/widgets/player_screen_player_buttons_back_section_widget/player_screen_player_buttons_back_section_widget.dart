import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lofiii/logic/bloc/download/download_music_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../logic/cubit/flip_card/flip_card_cubit.dart';
import '../glass_button/glass_button_widget.dart';

class PlayerScreenPlayerButtonsBackSectionWidget extends StatelessWidget {
  const PlayerScreenPlayerButtonsBackSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 0.05.sh),
        height: 0.28.sh,
        width: 0.8.sw,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    context.read<FlipCardCubit>().toggleCard();
                  },
                  icon: const Icon(
                    Icons.flip,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                FetchCurrentPlayingMusicDataToPlayerState>(
              builder: (context, currentlyPlayingMusicState) {
                return BlocBuilder<NowPlayingOfflineMusicDataToPlayerCubit,
                    NowPlayingOfflineMusicDataToPlayerState>(
                  builder: (context, nowPlayingState) {
                    ///!----- Check Music is Downloaded (Available In Local Storage ) Are Not ----------///
                    // // Check if music is already downloaded
                    // bool isDownloaded = nowPlayingState.snapshotMusicList
                    //     ?.any((e) => e.title.trim().toLowerCase().contains(currentlyPlayingMusicState
                    //     .fullMusicList[currentlyPlayingMusicState.musicIndex]
                    //     .title.trim().toLowerCase()))??false;

                    // if (isDownloaded) {
                    //   return const Center(
                    //     child: Text(
                    //       "Music is Already Downloaded",
                    //       style: TextStyle(
                    //           color: Colors.white, fontWeight: FontWeight.w500),
                    //     ),
                    //   );
                    // }

                    ///!---------- If already not Downloaded shows this
                    // else {
                      return
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///!-------  Download Button ------////
                            ZoomIn(
                              child: BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                                  FetchCurrentPlayingMusicDataToPlayerState>(
                                builder: (context, fetchMusicState) {
                                  return BlocBuilder<DownloadMusicBloc,
                                      DownloadMusicState>(
                                    builder: (context, state) {
                                      if (state is DownloadMusicInitialState) {
                                        return Center(
                                            child: GlassButtonWidget(
                                          onPressed: () {
                                            context.read<DownloadMusicBloc>().add(
                                                DownloadNowEvent(
                                                    url: fetchMusicState
                                                        .fullMusicList[
                                                            fetchMusicState
                                                                .musicIndex]
                                                        .url,
                                                    fileName: fetchMusicState
                                                        .fullMusicList[
                                                            fetchMusicState
                                                                .musicIndex]
                                                        .title,
                                                    context: context));
                                          },
                                          label: "Download Now",
                                          iconData: FontAwesomeIcons.download,
                                        ));
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ]);
                    // }
                  },
                );
              },
            ),

            ///!-----------   Downloading Status ---------------///
            Center(
              child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
                builder: (context, themeState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///!----------- Downloading Status ------/////

                      BlocBuilder<DownloadMusicBloc, DownloadMusicState>(
                          builder: (context, state) {
                        if (state is DownloadMusicLoadingState) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.spMax),
                                child: Text(
                                  "${state.fileName} is Downloading",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.spMax,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        } else if (state is DownloadMusicProgressState) {
                          return CircularPercentIndicator(
                            radius: 50,
                            animation: true,
                            backgroundColor: Colors.white,
                            progressColor: Colors.pink,
                            lineWidth: 5,
                            center: Text(
                              "${state.progress.toInt()}%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        } else if (state is DownloadMusicSuccessState) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${state.fileName} is Successfully Download",
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.spMax,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }

                        ///---- Download Music Failure State
                        else if (state is DownloadMusicFailureState) {
                          return Padding(
                            padding: EdgeInsets.all(12.spMax),
                            child: Text(
                              "${state.errorMessage}",
                              maxLines: 5,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.spMax,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
