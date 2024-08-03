import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_music_player_page.dart';
import 'package:youtube_scrape_api/models/video.dart';

import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';

class YouTubeFavoritePlaylistPage extends StatefulWidget {
  const YouTubeFavoritePlaylistPage(
      {super.key,
      required this.musicList,
      required this.playlistThumbnail,
      required this.playlistTitle});

  final Future<List<Video>> musicList;
  final String playlistThumbnail;
  final String playlistTitle;

  @override
  State<YouTubeFavoritePlaylistPage> createState() =>
      _YouTubeFavoritePlaylistPageState();
}

class _YouTubeFavoritePlaylistPageState
    extends State<YouTubeFavoritePlaylistPage> {
  late ScrollController controller;
  int totalMusicCount = 0; // Variable to hold the total number of music tracks

  @override
  void initState() {
    // Initialize ScrollController
    controller = ScrollController();
    super.initState();

    // Calculate the total number of music tracks
    widget.musicList.then((list) {
      setState(() {
        totalMusicCount = list.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[900], // Set a dark background color for the page
      body: Stack(
        children: [
          ///!------------------ Background Image with Blur Effect -------------///
          ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: 15, sigmaY: 15), // Moderate blur effect
            child: CachedNetworkImage(
              imageUrl: widget.playlistThumbnail,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                        BlendMode.darken), // Add a dark overlay
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox(),
            ),
          ),

          ///?----------------------- Main Content ------------///
          Scrollbar(
            controller: controller, // Attach the scrollbar to the controller
            thumbVisibility: true, // Always show scrollbar
            radius: Radius.circular(10), // Rounded edges for scrollbar
            thickness: 8, // Thickness of the scrollbar
            child: ListView(
              controller: controller,
              children: [
                ///!---------------------- Header Image -----------------////
                Container(
                  height: 0.35.sh, // Slightly smaller header image
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight:
                            Radius.circular(15)), // Soft rounded corners
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.playlistThumbnail,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken), // Darker overlay to make text pop
                    ),
                  ),
                  child: Stack(
                    children: [
                      ///!------ Back Button
                      Positioned(
                        top: 0.05.sh, // Adjusted position
                        left: 0.02.sw,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                              size: 28.sp, // Slightly smaller icon
                            )),
                      ),

                      ///!------ Playlist Title with Total Music Number
                      Positioned(
                        bottom: 0.05.sh, // Moved up slightly for a cleaner look
                        left: 0.05.sw,
                        child: Text(
                          '${widget.playlistTitle} - $totalMusicCount Tracks', // Added total number of tracks
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600, // Medium weight for subtlety
                            fontSize: 22.sp, // Slightly reduced size
                            shadows: [
                              Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black.withOpacity(0.7),
                                  offset: const Offset(2,
                                      2)), // Subtle shadow for better readability
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///!--------------------------  Music List ----------------------///
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.sp, horizontal: 16.sp), // Consistent padding
                  child: FutureBuilder(
                      future: widget.musicList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevents the inner list from scrolling
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final thumbnail = snapshot
                                  .data![index].thumbnails!.last.url
                                  .toString();
                              final title =
                                  snapshot.data![index].title.toString();
                              final videoId =
                                  snapshot.data![index].videoId.toString();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0), // Spacing between items
                                child:
                                    BlocBuilder<ThemeModeCubit, ThemeModeState>(
                                  builder: (context, themeState) {
                                    return GestureDetector(
                                      onTap: () {
                                        _listTileOnTap(
                                            videoId, snapshot, index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15), // Rounded corners
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(themeState.accentColor),
                                              Color.fromARGB(226, 25, 20, 20),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5, sigmaY: 5),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 15,
                                                  horizontal:
                                                      16), // Balanced padding
                                              leading: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${index + 1}', // Display the index + 1 as the number
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16
                                                          .sp, // Number font size
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          15), // Space between number and thumbnail
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // Rounded corners for thumbnail
                                                    child: CachedNetworkImage(
                                                      imageUrl: thumbnail,
                                                      width: 60.sp,
                                                      height: 60.sp,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              title: Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 16
                                                      .sp, // Normal-sized font
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors
                                                      .white, // Consistent text color
                                                ),
                                                maxLines:
                                                    null, // Allow title to wrap to multiple lines
                                                overflow: TextOverflow
                                                    .visible, // Display full title
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.error.toString()),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///?------------------------------------------------------------------------------------------------////
  ///!----------------------------------------------  Methods ---------------------------------------/////
  void _listTileOnTap(
      String videoId, AsyncSnapshot<List<Video>> snapshot, int index) async {
    ///----- Hide Status Bar Values
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
    context.read<MusicPlayerBloc>().add(MusicPlayerDisposeEvent());

    ///!---- Initialize Player

    context.read<YoutubeMusicPlayerCubit>().initializePlayer(videoId: videoId);

    ///!-----Show Player Screen ----///
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubeMusicPlayerPage(),
        )).then((value) {
      ///!-----Show Mini Player-----///
      context.read<ShowMiniPlayerCubit>().showMiniPlayer();
      context.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();

      ///!-----Send Current Music Data-----///

      context
          .read<CurrentlyPlayingMusicDataToPlayerCubit>()
          .sendYouTubeDataToPlayer(
              youtubeList: snapshot.data!, musicIndex: index);
    });
  }
}
