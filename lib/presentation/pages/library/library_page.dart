import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:lofiii/base/assets/app_fonts.dart';
import 'package:lofiii/logic/bloc/fetch_lofiii_music_from_internet/lofiii_music_bloc.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';

import 'exports.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              ///-------------------------- App Bar ----------------------///
              const SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                title: Text(
                  "Library",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              ///!-   --------------       My Favorite
              BlocBuilder<OnlineMusicFavoriteButtonBloc,
                  OnlineMusicFavoriteButtonState>(
                builder: (context, favoriteState) {
                  return BlocBuilder<LofiiiMusicBloc, LofiiiMusicState>(
                    builder: (context, state) {
                      ///?------------        If  Success State
                      if (state is LofiiiMusicSuccessState) {
                        //! Filter the favorite list
                        final favoriteList = state.combinedMusicList
                            .where((element) => favoriteState.favoriteList
                                .contains(element.title))
                            .toList();

                        //! Heading with View More Button Widget
                        return favoriteList.isNotEmpty
                            ? HeadingWithViewMoreButton(
                                heading: "My Online Favorite ❤️",
                                viewMoreOnTap: () {
                                  //! Navigate to View More Page with filtered list
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewMoreOnlineMusicPage(
                                        topHeading: "My Favorite ❤️",
                                        musicList: favoriteList,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const SliverToBoxAdapter();
                      } else {
                        return const SliverToBoxAdapter();
                      }
                    },
                  );
                },
              ),

              ///!       -------------Online Favorite List
              BlocBuilder<OnlineMusicFavoriteButtonBloc,
                  OnlineMusicFavoriteButtonState>(
                builder: (context, favoriteState) {
                  return BlocBuilder<LofiiiMusicBloc, LofiiiMusicState>(
                    builder: (context, state) {
                      ///?------------        If  Success State
                      if (state is LofiiiMusicSuccessState) {
                        //!  Filter the favorite list
                        final favoriteList = state.combinedMusicList
                            .where((element) => favoriteState.favoriteList
                                .contains(element.title))
                            .toList();

                        if (favoriteList.isNotEmpty) {
                          //!  Display the filtered favorite list using MusicCardsListWidget
                          return MusicCardsListWidget(
                            list: favoriteList,
                            pageStorageKey: "favoriteStorageKey",
                          );
                        }

                        // ///!-------   If Favorite list is Empty
                        // else {
                        //   return SliverToBoxAdapter(
                        //     child: SizedBox(
                        //       height: 0.30.sh,
                        //       width: double.infinity,
                        //       child: const Center(
                        //         child: Text("No Favorite Items available"),
                        //       ),
                        //     ),
                        //   );
                        // }
                        else {
                          return const SliverToBoxAdapter();
                        }
                      }
                      //?-----------            If Loading State
                      else if (state is LofiiiMusicLoadingState) {
                        return const SliverToBoxAdapter(
                            child: ListViewShimmerBoxWidget());
                      }
                      //?-----------              If failure State
                      else {
                        return const SliverToBoxAdapter();
                      }
                    },
                  );
                },
              ),

              ///---------------------- Offline Favorite -------------------------
              HeadingWithViewMoreButton(
                  heading: "Offline Favorite List", viewMoreOnTap: () {}),

              BlocBuilder<FetchFavoriteMusicFromLocalStorageBloc,
                  FetchFavoriteMusicFromLocalStorageState>(
                builder: (context, state) {
                  if (state is FetchFavoriteMusicFromLocalStorageSuccessState) {
                    List<LocalMusicModel> musicList = state.favoriteMusicList;

                    return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
                        NowPlayingMusicDataToPlayerState>(
                      builder: (context, nowPlayingState) {
                        return BlocBuilder<ThemeModeCubit, ThemeModeState>(
                          builder: (context, themeState) {
                            return SliverToBoxAdapter(
                              child: FadeInDown(
                                child: SizedBox(
                                  // color: Colors.amber,
                                  height: 0.37.sh,
                                  width: 1.sw,
                                  child: musicList.isNotEmpty
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: musicList.length,
                                          itemBuilder: (context, index) {
                                            LocalMusicModel music =
                                                musicList[index];
                                            bool isSelected = music.uri ==
                                                nowPlayingState.uri;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  ///--------- Music Card------------///
                                                  Card(
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: isSelected
                                                                ? Color(themeState
                                                                    .accentColor)
                                                                : Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      height: isSelected
                                                          ? 0.26.sh
                                                          : 0.25.sh,
                                                      width: isSelected
                                                          ? 0.5.sw
                                                          : 0.4.sw,
                                                      child: Stack(
                                                        children: [
                                                          ///-------------- Music Card ----------------------///

                                                          music.artwork == null
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    _musicOnTap(
                                                                        currentMusic:
                                                                            music
                                                                                .uri,
                                                                        musicList:
                                                                            musicList,
                                                                        index:
                                                                            index,
                                                                        musicTitle:
                                                                            music
                                                                                .title,
                                                                        artistsName:
                                                                            music
                                                                                .artist,
                                                                        musicListLength:
                                                                            musicList
                                                                                .length,
                                                                        uri: music
                                                                            .uri,
                                                                        musicId:
                                                                            music
                                                                                .id,
                                                                        nowPlayingUri:
                                                                            nowPlayingState.uri);
                                                                  },

                                                                  ///------------- Icon -------------------///
                                                                  child:
                                                                      WidgetAnimator(
                                                                    atRestEffect: isSelected
                                                                        ? WidgetRestingEffects
                                                                            .swing()
                                                                        : WidgetRestingEffects
                                                                            .none(),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Icon(
                                                                        EvaIcons
                                                                            .music,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    _musicOnTap(
                                                                        currentMusic:
                                                                            music
                                                                                .uri,
                                                                        musicList:
                                                                            musicList,
                                                                        index:
                                                                            index,
                                                                        musicTitle:
                                                                            music
                                                                                .title,
                                                                        artistsName:
                                                                            music
                                                                                .artist,
                                                                        musicListLength:
                                                                            musicList
                                                                                .length,
                                                                        uri: music
                                                                            .uri,
                                                                        musicId:
                                                                            music
                                                                                .id,
                                                                        nowPlayingUri:
                                                                            nowPlayingState.uri);
                                                                  },
                                                                  //----------- Thumbnail -------------//
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      image: DecorationImage(
                                                                          image: MemoryImage(
                                                                            music.artwork!,
                                                                          ),
                                                                          filterQuality: FilterQuality.high,
                                                                          fit: BoxFit.cover),
                                                                    ),
                                                                  ),
                                                                ),

                                                          ///-------------- More Icon Button-------------///
                                                          GestureDetector(
                                                            onTapDown:
                                                                (detail) {
                                                              _moreIconButtonTap(
                                                                  detail,
                                                                  music);
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 15.sp,
                                                                  backgroundColor: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.6),
                                                                  child: Icon(
                                                                    Icons
                                                                        .more_vert,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 18.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const Gap(4),

                                                  ///-------------- Music Title-------------///
                                                  SizedBox(
                                                    // color: Colors.green,
                                                    height: 0.05.sh,
                                                    width: 0.4.sw,
                                                    child: Text(
                                                      music.title,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily: AppFonts
                                                              .poppinBold,
                                                          fontWeight: isSelected
                                                              ? FontWeight.bold
                                                              : null,
                                                          letterSpacing:
                                                              isSelected
                                                                  ? 1.5
                                                                  : null,
                                                          wordSpacing:
                                                              isSelected
                                                                  ? -2
                                                                  : null),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                      : const Center(
                                          child: Text(
                                              "No Favorite Music is found"),
                                        ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 0.3.sh,
                        width: 1.sw,
                        child: Center(
                          child: TextAnimator(
                            atRestEffect: WidgetRestingEffects.rotate(),
                            "Loading...",
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 0.2.sh,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _musicOnTap(
      {required List<LocalMusicModel> musicList,
      required int index,
      currentMusic,
      required musicTitle,
      required artistsName,
      required musicListLength,
      required uri,
      required int musicId,
      required nowPlayingUri}) {
    if (nowPlayingUri != uri) {
      ///!-----Play Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: currentMusic,
          isOnlineMusic: false,
          musicAlbum: musicList[index].album ?? "Unknown",
          musicId: musicId,
          musicTitle: musicTitle,
          onlineMusicThumbnail: null,
          offlineMusicThumbnail: musicList[index].artwork,
          artist: artistsName));
    }

    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().offlineMusicIsPlaying();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();

    //!-----Show Offline Player Screen ----///
    if (nowPlayingUri == uri) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const OfflinePlayerPage(),
      );
    }

    if (nowPlayingUri != uri) {
      ///!---- Send Data to Offline Player
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: musicList,
          musicThumbnail: musicList[index].artwork,
          musicTitle: musicTitle,
          musicArtist: artistsName,
          musicListLength: musicListLength,
          uri: uri,
          musicId: musicId);
    }
  }

  _moreIconButtonTap(detail, music) {
    setState(() {});
    MyMenu.showMenuAtPosition(
      context: context,
      position: detail.globalPosition,
      items: [
        PopupMenuItem(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
            title: const Text(
              "Remove",
              maxLines: 1,
            ),
            trailing: const Icon(Icons.delete),
            onTap: () {
              context
                  .read<LocalMusicToFavoriteMusicListCubit>()
                  .removeMusicToFavorite(context, musicId: music.id.toString());
              context
                  .read<FetchFavoriteMusicFromLocalStorageBloc>()
                  .add(FetchFavoriteMusicFromLocalStorageInitializationEvent());
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
