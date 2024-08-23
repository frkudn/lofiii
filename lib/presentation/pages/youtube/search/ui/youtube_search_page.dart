import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/logic/cubit/now_playing_music_data_to_player/now_playing_music_data_to_player_cubit.dart';

import '../../../../../logic/bloc/player/music_player_bloc.dart';
import '../../../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../../common/mini_player_widget.dart';

class YouTubeSearchPage extends StatefulWidget {
  const YouTubeSearchPage({super.key});

  @override
  State<YouTubeSearchPage> createState() => _YouTubeSearchPageState();
}

class _YouTubeSearchPageState extends State<YouTubeSearchPage> {
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Column(
          children: [
            Gap(0.05.sh),

            ///!-----------------------Search Text Field --------------------------///
            Row(
              children: [
                ///!----------Back Button------//
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                    )),

                ///---------Field---------///
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.sp),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.sp,
                      ),
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                        maxLines: 1,
                        enableSuggestions: true,
                        onTapOutside: (event) {
                          ///----Hide keyboard if active
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Music",
                          border: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
              ],
            ),

            Gap(0.01.sh),

            ///!------------  Mini Player --------------///
            ///--------Show Mini Player First whenever music card is clicked
            BlocBuilder<ShowMiniPlayerCubit, ShowMiniPlayerState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.showMiniPlayer,
                  child: FadeInUp(
                    child: MiniPlayerPageWidget(
                      playerHeight: 0.1.sh,
                      playerWidth: 1.sw,
                      paddingBottom: 0.1,
                      paddingTop: 0.0,
                      bottomMargin: 0.0,
                      playerAlignment: Alignment.bottomCenter,
                      borderRadiusTopLeft: 0.0,
                      borderRadiusTopRight: 0.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ]),
    );
  }

  _playMusic(
    BuildContext context, {
    required videoId,
    required videosList,
    required index,
  }) async {
    context.read<MusicPlayerBloc>().add(MusicPlayerDisposeEvent());

    ///!------- Initialize Player
    // context.read<YoutubeMusicPlayerCubit>().initializePlayer(videoId: videoId);

    ///!-----Show Player Screen ----///
    // Navigator.pushNamed(context, AppRoutes.youtubeMusicPlayerRoute);

    context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
        musicIndex: index,
        musicList: videosList,
        musicThumbnail: videosList[index].thumbnails!.last.url,
        musicTitle: videosList[index].title!,
        uri: videosList[index].videoId,
        musicArtist: videosList[index].channelName,
        musicListLength: videosList.length,
        musicId: 1);

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();
  }
}
