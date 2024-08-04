import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/logic/cubit/youtube_music/youtube_music_cubit.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_music_player_page.dart';
import 'package:lofiii/presentation/widgets/common/listViewShimmerBoxWidget.dart';
import 'package:lofiii/presentation/widgets/music_cards_list/music_cards_list_widget.dart';
import 'package:one_context/one_context.dart';

import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import '../../widgets/mini_player/mini_player_widget.dart';

class YouTubeSearchPage extends StatefulWidget {
  const YouTubeSearchPage({super.key});

  @override
  State<YouTubeSearchPage> createState() => _YouTubeSearchPageState();
}

class _YouTubeSearchPageState extends State<YouTubeSearchPage> {
  late TextEditingController controller;
  late ScrollController _scrollController;
  @override
  void initState() {
    controller = TextEditingController();
    _scrollController = ScrollController();
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
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, ),
                        
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          onSubmitted: (value) {
                            context
                                .read<YoutubeMusicCubit>()
                                .searchMusic(query: value);
                          },
                          onChanged: (value) {
                            context
                                .read<YoutubeMusicCubit>()
                                .searchMusic(query: value);
                            _scrollController.jumpTo(0);
                          },
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

              ///!---------------------- Search List ----------------------------////
              BlocBuilder<YoutubeMusicCubit, YoutubeMusicState>(
                builder: (context, state) {
                  if (state is YoutubeMusicSearchState) {
                    return FutureBuilder(
                        future: state.searchList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: ListViewShimmerBoxWidget(
                                  showHeader: false,
                                  scrollDirection: Axis.vertical,
                                  boxWidth: 1.sw,
                                  boxHeight: 1.sh,
                                  itemHeight: 0.23.sh,
                                  itemWidth: 1.sw,
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.hasData) {
                              return Expanded(
                                child: PageStorage(
                                  bucket: pageBucket,
                                  child: ListView.builder(
                                      key: const PageStorageKey(
                                          "Youtube Search"),
                                      controller: _scrollController,
                                      padding: EdgeInsets.only(bottom: 0.1.sh),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final videoId = snapshot
                                            .data![index].videoId
                                            .toString();
                                        final thumbnail = snapshot
                                            .data![index].thumbnails!.last.url
                                            .toString();
                                        final videoTitle = snapshot
                                            .data![index].title
                                            .toString();
                                        final channelName = snapshot
                                            .data![index].channelName
                                            .toString();
                                        final videoDuration =
                                            snapshot.data![index].duration;
                                        final videoViews =
                                            snapshot.data![index].views;
                                        final uploadDate =
                                            snapshot.data![index].uploadDate;

                                        ///---------------------- Item Box -----------------------///
                                        return GestureDetector(
                                          onTap: () {
                                            _playMusic(
                                              context,
                                              videoId: videoId,
                                              videosList: snapshot.data,
                                              index: index,
                                            );
                                          },
                                          child: Card(
                                            color: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            elevation: 8,
                                            shadowColor: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(0.2),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ///!------------Thumbnail ----------------///
                                                  Container(
                                                    height: 0.22.sh,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .shadowColor
                                                              .withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              thumbnail),
                                                          filterQuality:
                                                              FilterQuality.low,
                                                          fit: BoxFit.cover),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.sp),

                                                    //!------------------------- Video Duration
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    8.sp,
                                                                vertical: 4.sp),
                                                        margin: EdgeInsets.only(
                                                            right: 8.sp,
                                                            bottom: 8.sp),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black87
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                          videoDuration ?? "",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  ///!------- Video Title
                                                  Text(
                                                    videoTitle,
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.sp,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),

                                                  Gap(8.sp),

                                                  ///!------ Channel Name
                                                  Text(
                                                    channelName,
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.sp,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .color),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),

                                                  Gap(5.sp),

                                                  ///!------ Video Views & Upload Date
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.visibility,
                                                        size: 14.sp,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .color,
                                                      ),
                                                      Gap(5.sp),
                                                      Text(
                                                        videoViews ?? "",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .color),
                                                      ),
                                                      Gap(20.sp),
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 14.sp,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .color,
                                                      ),
                                                      Gap(5.sp),
                                                      Text(
                                                        uploadDate ?? "",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 12.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .color),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.error.toString()),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        });
                  } else if (state is YoutubeMusicLoadingState) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is YoutubeMusicErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.errorMessage),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),

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
    context.read<YoutubeMusicPlayerCubit>().initializePlayer(videoId: videoId);

    ///!-----Show Player Screen ----///
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubeMusicPlayerPage(),
        ));

    ///!-----Send Current Music Data-----///

    context
        .read<CurrentlyPlayingMusicDataToPlayerCubit>()
        .sendYouTubeDataToPlayer(youtubeList: videosList, musicIndex: index);

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();
  }
}
