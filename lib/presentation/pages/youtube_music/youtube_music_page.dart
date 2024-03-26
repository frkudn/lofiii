import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/logic/cubit/youtube_music/youtube_music_cubit.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_music_player_page.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_search_page.dart';
import 'package:lottie/lottie.dart';
import 'package:one_context/one_context.dart';
import 'package:youtube_scrape_api/models/video.dart';

import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import '../../../resources/my_assets/my_assets.dart';
import '../../widgets/youtube_favorite_playlist/youtube_favorite_playlists_widget.dart';

class YoutubeMusicPage extends StatefulWidget {
  const YoutubeMusicPage({super.key});

  @override
  State<YoutubeMusicPage> createState() => _YoutubeMusicPageState();
}

class _YoutubeMusicPageState extends State<YoutubeMusicPage> {


  @override
  void initState() {
    ///?--------------- Fetch Youtube Music ------------------///
    context.read<YoutubeMusicCubit>().fetchMusic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///------------APP BAR --------------///
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "LOFIIITube ",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp),
            ),
            const Icon(FontAwesomeIcons.youtube),

          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YouTubeSearchPage(),
                      ));
                },
                icon: const Icon(FontAwesomeIcons.searchengin)),
          )
        ],
      ),

      ///!-------------------------------------- Body ------------------------------///
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            primary: true,
            children: [
              ///?-----------------------------------------------------------------------------------------------------------///
              ///!----------------------------------- Trending  Section-------------------------------------
              ///?-----------------------------------------------------------------------------------------------------------///
              Text(
                "Trending Music",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    letterSpacing: 1.5),
              ),

              ///!------------------------------------ Trending List
              SizedBox(
                height: 0.25.sh,
                width: 1.sw,
                child: BlocBuilder<YoutubeMusicCubit, YoutubeMusicState>(
                  builder: (context, state) {
                    if (state is YoutubeMusicSuccessState) {
                      return FutureBuilder<List<Video>>(
                        future: state.musicList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                ///!-------- Video Item
                                final video = snapshot.data![index];
                                // Display your video item UI here
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 0.65.sw,
                                    child: GestureDetector(
                                      ///!--------------------------------------- ON TAP
                                      onTap: () {
                                        _trendingCardOnTap( video,
                                            snapshot, index, );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///!--------- Music Thumbnail
                                          CachedNetworkImage(
                                            ///!--------Music Image Url List-------///
                                            imageUrl: video
                                                .thumbnails!.last.url
                                                .toString(),

                                            ///!-------On Image Successfully Loaded---------///
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                surfaceTintColor:
                                                    Colors.transparent,
                                                color: Colors.transparent,
                                                margin: EdgeInsets.zero,
                                                child: Container(
                                                  height: 0.18.sh,
                                                  width: 0.65.sw,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            ///!----------------On Loading-------------///
                                            placeholder: (context, url) =>
                                                BlocBuilder<ThemeModeCubit,
                                                    ThemeModeState>(
                                              builder: (context, state) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Container(
                                                    height: 0.18.sh,
                                                    width: 0.65.sw,
                                                    decoration:
                                                        BoxDecoration(
                                                      color: Colors
                                                          .transparent,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      border: Border.all(
                                                          color: Color(state
                                                                  .accentColor)
                                                              .withOpacity(
                                                                  0.7),
                                                          width: 2),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                      child: Center(
                                                        child: Lottie.asset(
                                                            MyAssets
                                                                .lottieLoadingAnimation),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            ///!----------------On Error-------------///
                                            errorWidget:
                                                (context, url, error) =>
                                                    BlocBuilder<
                                                        ThemeModeCubit,
                                                        ThemeModeState>(
                                              builder: (context, state) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                  child: Container(
                                                    height: 0.18.sh,
                                                    width: 0.65.sw,
                                                    decoration:
                                                        BoxDecoration(
                                                      color: Colors
                                                          .transparent,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      border: Border.all(
                                                          color: Color(state
                                                              .accentColor),
                                                          width: 2),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .music,
                                                            size: 38.spMax,
                                                          )),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          ///!--------- Music Title
                                          Text(
                                            video.title.toString(),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(fontSize: 12.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }  else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),

              Gap(0.02.sh),

              ///?-----------------------------------------------------------------------------------------------------------///
              ///!----------------------------------- Favorite Playlists  Section-------------------------------------
              ///?-----------------------------------------------------------------------------------------------------------///
              Text(
                "Lo-Fi Playlists",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    letterSpacing: 1.5),
              ),

              Gap(0.01.sh),
              const YoutubeFavoritePlaylistWidget(),

              Gap(0.2.sh),
            ],
          ),
        ),
      ),
    );
  }

  ///?------------------------------------------------------------------------///
  ///!-------------------------------- Methods ------------------------------///

  void _trendingCardOnTap(Video video,
      AsyncSnapshot<List<Video>> snapshot, int index,) async {


    ///!---- Initialize Player
        OneContext().context!.read<YoutubeMusicPlayerCubit>()
        .initializePlayer(videoId: video.videoId);

    ///!-----Show Player Screen ----///

    OneContext().push(MaterialPageRoute(
      builder: (context) =>   YouTubeMusicPlayerPage(),
    ));

    ///!-----Send Current Music Data-----///
        OneContext().context!.read<CurrentlyPlayingMusicDataToPlayerCubit>()
        .sendYouTubeDataToPlayer(
            youtubeList: snapshot.data!, musicIndex: index);

    ///!-----Show Mini Player-----///
        OneContext().context!.read<ShowMiniPlayerCubit>().showMiniPlayer();
        OneContext().context!.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();
  }

  Future _onRefresh() async {
    ///?--------------- Fetch Youtube Music ------------------///
    OneContext().context!.read<YoutubeMusicCubit>().fetchMusic();
  }
}
