import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:lofiii/presentation/pages/youtube_music/youtube_music_player_page.dart';
import 'package:one_context/one_context.dart';
import 'package:youtube_scrape_api/models/video.dart';

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
  final playlistThumbnail;
  final playlistTitle;

  @override
  State<YouTubeFavoritePlaylistPage> createState() =>
      _YouTubeFavoritePlaylistPageState();
}

class _YouTubeFavoritePlaylistPageState
    extends State<YouTubeFavoritePlaylistPage> {
  late ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///!------------------ Background Image -------------///
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: CachedNetworkImage(
              imageUrl: widget.playlistThumbnail,
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
          ),

          ///?----------------------- Main Content ------------///
          ListView(
            controller: controller,
            children: [
              ///!---------------------- Header Image -----------------////
              Container(
                height: 0.3.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      strokeAlign: BorderSide.strokeAlignInside),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.playlistThumbnail.toString(),
                      ),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    ///!------ Back Button
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 35.sp,
                        )),

                    ///!------ Playlist Title
                    Positioned(
                        bottom: 0.02.sh,
                        left: 0.02.sw,
                        width: 1.sw,
                        child: Text(
                          widget.playlistTitle,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp),
                        )),
                  ],
                ),
              ),

              ///!--------------------------  Music List ----------------------///
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 4.sp),
                child: FutureBuilder(
                    future: widget.musicList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            controller: controller,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              ///!---- Data
                              final thumbnail = snapshot
                                  .data![index].thumbnails!.last.url
                                  .toString();
                              final title =
                                  snapshot.data![index].title.toString();
                              final videoId =
                                  snapshot.data![index].videoId.toString();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 4),
                                child: BlocBuilder<ThemeModeCubit,
                                    ThemeModeState>(
                                  builder: (context, themeState) {
                                    ///!--- Tile
                                    return ListTile(
                                      onTap: () {
                                        _listTileOnTap(videoId, snapshot,
                                            index, );
                                      },
                                      titleTextStyle: TextStyle(
                                          color: Colors.white
                                              .withOpacity(0.9)),
                                      iconColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      tileColor:
                                          Color(themeState.accentColor)
                                              .withOpacity(0.1),

                                      ///! ---- Thumbnail
                                      leading: CircleAvatar(
                                        maxRadius: 25.spMax,
                                        minRadius: 20.spMin,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                thumbnail),
                                      ),

                                      ///! ---- title
                                      title: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 14.sp,
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
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///?------------------------------------------------------------------------------------------------////
  ///!----------------------------------------------  Methods ---------------------------------------/////
  void _listTileOnTap(String videoId, AsyncSnapshot<List<Video>> snapshot,
      int index, ) {


    ///!---- Initialize Player
    OneContext()
        .context!
        .read<YoutubeMusicPlayerCubit>()
        .initializePlayer(videoId: videoId);

    ///!-----Show Player Screen ----///
    OneContext()
        .push(MaterialPageRoute(
      builder: (context) =>  YouTubeMusicPlayerPage(),
    ))
        .then((value) {
      ///!-----Show Mini Player-----///
      OneContext().context!.read<ShowMiniPlayerCubit>().showMiniPlayer();
      OneContext().context!.read<ShowMiniPlayerCubit>().youtubeMusicIsPlaying();

      ///!-----Send Current Music Data-----///
      OneContext()
          .context!
          .read<CurrentlyPlayingMusicDataToPlayerCubit>()
          .sendYouTubeDataToPlayer(
              youtubeList: snapshot.data!, musicIndex: index);
    });
  }
}
