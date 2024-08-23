// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:lofiii/data/models/music_model.dart';
import 'package:lofiii/logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';
import 'package:lofiii/presentation/pages/view-more-online-music/widgets/view_more_page_mini_player_widget.dart';
import 'package:one_context/one_context.dart';
import '../../../../logic/cubit/gridview_max_count/gridview_max_count_cubit.dart';

class ViewMoreOnlineMusicPage extends StatefulWidget {
  const ViewMoreOnlineMusicPage({
    super.key,
    required this.topHeading,
    required this.musicList,
  });

  final String topHeading;
  final List<MusicModel> musicList;

  @override
  State<ViewMoreOnlineMusicPage> createState() =>
      _ViewMoreOnlineMusicPageState();
}

class _ViewMoreOnlineMusicPageState extends State<ViewMoreOnlineMusicPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Scaffold(
          ///!-------------  App Bar-------------------///
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  OneContext().pop();
                },
                icon: const Icon(CupertinoIcons.back)),
            title: Text(
              widget.topHeading,
            ),
            actions: [
              IconButton(onPressed: () {
                context.read<GridViewMaxCountCubit>().changeMaxCount();
              }, icon:
                  BlocBuilder<GridViewMaxCountCubit, GridviewMaxCountState>(
                builder: (context, state) {
                  if (state.maxCount == 3) {
                    return const Icon(CupertinoIcons.circle_grid_3x3);
                  } else if (state.maxCount == 2) {
                    return const Icon(Icons.grid_view);
                  } else {
                    return const Icon(Icons.check_box_outline_blank);
                  }
                },
              ))
            ],
          ),

          ///!------------- Body -------------------------///
          body: Stack(
            fit: StackFit.expand,
            children: [
              ///? ----------------  Music List --------------------///
              BlocBuilder<GridViewMaxCountCubit, GridviewMaxCountState>(
                builder: (context, maxCountState) {
                  return FadeInDownBig(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(
                          5.spMax, 1.spMax, 5.spMax, 60.spMax),
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: maxCountState.maxCount,
                          crossAxisSpacing: maxCountState.maxCount == 2
                              ? 0.02.sw
                              : maxCountState.maxCount == 1
                                  ? 0.02.sw
                                  : 0.03.sw,
                          mainAxisSpacing: maxCountState.maxCount == 2
                              ? maxCountState.maxCount == 1
                                  ? 0.0.sh
                                  : 0.01.sh
                              : 0.03.sh),
                      itemCount: widget.musicList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          playMusicMethod(index, context, widget.musicList);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///---------------------!Image---------///
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(themeState.accentColor)
                                          .withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) =>
                                        const Center(
                                      child: Icon(FontAwesomeIcons.music),
                                    ),
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      widget.musicList[index].image,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Gap(0.01.sh),

                            ///!------------------------ Music Title & Artist --------------///
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: themeState.isDarkMode
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.musicList[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: maxCountState.maxCount ==
                                                    1
                                                ? 20.spMax
                                                : maxCountState.maxCount == 3
                                                    ? 10.spMax
                                                    : 15.spMax,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        widget.musicList[index].artists
                                            .join(
                                              ", ",
                                            )
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: maxCountState.maxCount == 1
                                              ? 14.spMax
                                              : maxCountState.maxCount == 3
                                                  ? 8.spMax
                                                  : 10.spMax,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Gap(0.005.sh)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              ///? Mini Player ---------////
              ///!--------Show Mini Player First whenever music card is clicked
              const ViewMorePageMiniPlayerWidget(),
            ],
          ),
        );
      },
    );
  }

  ///? ----------------- M E T H O D S----------------///
  void playMusicMethod(
      int index, BuildContext context, List<MusicModel> musicList) {
    final music = musicList[index];

    ///!---------      Initialize & Play Music ------///
    context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
        url: music.url,
        isOnlineMusic: true,
        musicTitle: music.title,
        musicAlbum: widget.topHeading,
        musicId: music.id,
        onlineMusicThumbnail: music.image,
        offlineMusicThumbnail: null));

    ///!-----       Send Current Music Data-----///

    context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: musicList,
          musicThumbnail: musicList[index].image.toString(),
          musicTitle: musicList[index].title,
          uri: musicList[index].url,
          musicId: musicList[index].id,
          musicArtist: musicList[index].artists,
          musicListLength: musicList.length,
        );

    ///!-----        Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();
    context
        .read<YoutubeMusicPlayerCubit>()
        .disposePlayer(state: context.watch<YoutubeMusicPlayerCubit>().state);
  }
}
