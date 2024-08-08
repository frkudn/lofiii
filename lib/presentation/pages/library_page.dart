import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/logic/cubit/localMusicToFavorite/local_music_to_favorite_music_list_cubit.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import 'package:lofiii/presentation/pages/player/offline_player_page.dart';
import 'package:lofiii/presentation/pages/view_more/view_more_page.dart';
import 'package:lofiii/presentation/widgets/common/listViewShimmerBoxWidget.dart';
import 'package:lofiii/utils/menu_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../logic/bloc/favorite_button/favorite_button_bloc.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_state.dart';
import '../widgets/heading_with_view_more_button/heading_with_view_more_button_widget.dart';
import '../widgets/music_cards_list/music_cards_list_widget.dart';
import '../widgets/lottie_animation/no_internet_lottie_animation_widget.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<FetchMusicFromLocalStorageBloc>()
        .add(FetchFavoriteMusicFromLocalStorageInitializationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Library",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ///!-   --------------       My Favorite
          BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
            builder: (context, favoriteState) {
              return BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                builder: (context, state) {
                  ///?------------        If  Success State
                  if (state is LofiiiAllMusicSuccessState) {
                    //! Filter the favorite list
                    final favoriteList = state.musicList
                        .where((element) =>
                            favoriteState.favoriteList.contains(element.title))
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
                                  builder: (context) => ViewMorePage(
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
          BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
            builder: (context, favoriteState) {
              return BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                builder: (context, state) {
                  ///?------------        If  Success State
                  if (state is LofiiiAllMusicSuccessState) {
                    //!  Filter the favorite list
                    final favoriteList = state.musicList
                        .where((element) =>
                            favoriteState.favoriteList.contains(element.title))
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
                  else if (state is LofiiiAllMusicLoadingState) {
                    return SliverToBoxAdapter(
                        child: ListViewShimmerBoxWidget());
                  }
                  //?-----------              If failure State
                  else {
                    return const SliverToBoxAdapter(
                        child: NoInternetLottieAnimation());
                  }
                },
              );
            },
          ),

          ///---------------------- Offline Favorite -------------------------
          HeadingWithViewMoreButton(
              heading: "Offline Favorite List", viewMoreOnTap: () {}),

          BlocBuilder<FetchMusicFromLocalStorageBloc,
              FetchMusicFromLocalStorageState>(
            builder: (context, state) {
              if (state is FetchFavoriteMusicFromLocalStorageSuccessState) {
                List<SongModel> musicList = state.musicsList;

                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 0.3.sh,
                    width: 1.sw,
                    child: state.musicsList.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.musicsList.length,
                            itemBuilder: (context, index) {
                              SongModel music = musicList[index];
                              return InkWell(
                                onTap: () {
                                  _musicOnTap(
                                      currentMusic: music.uri,
                                      musicList: musicList,
                                      index: index,
                                      musicTitle: music.title,
                                      artistsName: music.artist,
                                      musicListLength: musicList.length,
                                      snapshotMusicList: musicList);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: 0.3.sh,
                                      width: 0.4.sw,
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTapDown: (detail) {
                                              MenuHelper.showMenuAtPosition(
                                                  context: context,
                                                  position:
                                                      detail.globalPosition,
                                                  items: [
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                LocalMusicToFavoriteMusicListCubit>()
                                                            .removeMusicToFavorite(
                                                                music.title);
                                                        context
                                                            .read<
                                                                FetchMusicFromLocalStorageBloc>()
                                                            .add(
                                                                FetchFavoriteMusicFromLocalStorageInitializationEvent());
                                                      },
                                                      child: const ListTile(
                                                        title: Text(
                                                            "Remove Music"),
                                                        trailing:
                                                            Icon(Icons.remove),
                                                      ),
                                                    )
                                                  ]);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(Icons.more_vert),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              const Expanded(
                                                  child:
                                                      Icon(Icons.music_note)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Center(
                                                    child: Text(
                                                  state.musicsList[index].title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 11.sp),
                                                )),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : const Center(
                            child: Text("No Favorite Music is found"),
                          ),
                  ),
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
          )
        ],
      ),
    );
  }

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _musicOnTap(
      {required musicList,
      required index,
      currentMusic,
      required musicTitle,
      required artistsName,
      required musicListLength,
      required snapshotMusicList}) {
    ///!-----Play Music------
    context
        .read<MusicPlayerBloc>()
        .add(MusicPlayerInitializeEvent(url: currentMusic));

    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().offlineMusicIsPlaying();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();

    // ///!-----Show Offline Player Screen ----///
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const OfflinePlayerPage(),
    );

    ///!---- Send Data to Offline Player
    context.read<NowPlayingOfflineMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: musicList,
          musicTitle: musicTitle,
          musicArtist: artistsName,
          musicListLength: musicListLength,
        );
  }
}
