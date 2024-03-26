import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/logic/cubit/youtube_music/youtube_music_cubit.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_music_player_page.dart';
import 'package:lofiii/presentation/widgets/music_cards_list/music_cards_list_widget.dart';
import 'package:one_context/one_context.dart';

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
                        OneContext().pop();
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                      )),

                  ///---------Field---------///
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.purple.shade900.withOpacity(0.1)),
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        onSubmitted: (value) {
                          OneContext().context!
                              .read<YoutubeMusicCubit>()
                              .searchMusic(query: value);
                        },
                        onChanged: (value) {
                         OneContext().context!
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
                            return const Expanded(
                              child: Center(
                                child: CircularProgressIndicator(),
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
                                      padding:
                                          EdgeInsets.only(bottom: 0.1.sh),
                                      physics:
                                          const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final videoId = snapshot
                                            .data![index].videoId
                                            .toString();
                                        final thumbnail = snapshot
                                            .data![index]
                                            .thumbnails!
                                            .last
                                            .url
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
                                        final uploadDate = snapshot
                                            .data![index].uploadDate;

                                        ///---------------------- Item Box -----------------------///
                                        return GestureDetector(
                                          onTap: () {
                                            _playMusic(
                                                videoId: videoId,
                                                videosList: snapshot.data,
                                                index: index,
                                                );
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  ///!------------Thumbnail ----------------///
                                                  Container(
                                                    height: 0.24.sh,
                                                    width: 0.94.sw,
                                                    decoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      border: Border.all(
                                                          color:
                                                              Colors.white,
                                                          strokeAlign:
                                                              BorderSide
                                                                  .strokeAlignInside,
                                                          width: 0.3),
                                                      image: DecorationImage(
                                                          image:
                                                              NetworkImage(
                                                                  thumbnail),
                                                          filterQuality:
                                                              FilterQuality
                                                                  .low,
                                                          fit:
                                                              BoxFit.cover),
                                                    ),
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                            vertical: 5.sp),

                                                    //!------------------------- Video Duration
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                              videoDuration ??
                                                                  "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight.w500,
                                                                  shadows: [
                                                                    Shadow(
                                                                        color: Colors
                                                                            .black87,
                                                                        blurRadius:
                                                                            3,
                                                                        offset:
                                                                            Offset.zero)
                                                                  ]),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  ///!---------------- Video Title & Channel Name & Views ---------------------------///
                                                  Container(
                                                    width: 0.94.sw,
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                            horizontal:
                                                                10.sp,
                                                            vertical: 8.sp),
                                                    decoration:
                                                        BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(
                                                              0.15),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ///!------- Video Title
                                                        Text(
                                                          videoTitle,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Poppins"),
                                                        ),

                                                        ///!------ Channel Name
                                                        Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                                  top:
                                                                      8.sp),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      8.sp,
                                                                  horizontal:
                                                                      13.sp),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            channelName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  ///!----- Video Views & upload date
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ///!---Date
                                                        Text(
                                                          uploadDate ?? "",
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize:
                                                                  10.sp),
                                                        ),

                                                        ///!--- Views
                                                        Text(
                                                          videoViews ?? "",
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  11.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                  )));
            },
          ),
        ],
      ),
    );
  }

  _playMusic(
      {required videoId,
      required videosList,
      required index,
      }) async {


    ///!------- Initialize Player
    OneContext()
        .context!
        .read<YoutubeMusicPlayerCubit>()
        .initializePlayer(videoId: videoId);

    ///!-----Show Player Screen ----///
    OneContext()
        .push(MaterialPageRoute(
      builder: (context) =>   YouTubeMusicPlayerPage(),
    ));

    ///!-----Send Current Music Data-----///
    OneContext()
        .context!
        .read<CurrentlyPlayingMusicDataToPlayerCubit>()
        .sendYouTubeDataToPlayer(youtubeList: videosList, musicIndex: index);

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();
  }
}
