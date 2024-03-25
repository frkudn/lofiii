import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:lofiii/presentation/pages/player/offline_player_page.dart';
import 'package:lofiii/presentation/widgets/music_cards_list/music_cards_list_widget.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../logic/cubit/searchable_list_scroll_controller/searchableList_scroll_controller_cubit.dart';
import '../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../widgets/mini_music_visualizer/mini_music_visualizer_widget.dart';
import '../widgets/now_playing_position_floating_button/now_playing_position_floating_button_widget.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<FetchMusicFromLocalStorageBloc>()
        .add(FetchMusicFromLocalStorageInitializationEvent());
    locator.get<ScrollController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      ///!------------ App Bar ------------///
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
        title: Text(
          "L o c a l  M u s i c",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        ),
      ),

      ///!----------  Floating Action Button ------------------///
      floatingActionButton: const NowPlayingPositionFloatingButtonWidget(),


      ///!-------------   Body ---------//
      body:

          // !/------------------  Music List -----////
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, themeState) {
          return BlocConsumer<FetchMusicFromLocalStorageBloc,
              FetchMusicFromLocalStorageState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is FetchMusicFromLocalStorageSuccessState) {
                return FutureBuilder(
                    future: state.musicsList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final musicListLength = snapshot.data!.length;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.03.sw, vertical: 0.01.sh),
                          child: PageStorage(
                            bucket: pageBucket,

                            ///!-------- Animation ------///
                            child: SlideInDown(
                              duration: const Duration(milliseconds: 300),
                              child: SearchableList(
                                ///!-------- Scroll Controller ------//
                                scrollController:
                                    locator.get<ScrollController>(),
                                //! ----- For Storing List Position ------///
                                key: const PageStorageKey("LocalMusic"),

                                ///!------  Local Music List
                                initialList: snapshot.data!,

                                builder: (musicList, index, music) => ListTile(
                                  selected:
                                      themeState.localMusicSelectedTileIndex ==
                                              index
                                          ? true
                                          : false,
                                  selectedColor: Color(themeState.accentColor),

                                  ///!-------  On Tap
                                  onTap: () {
                                    _listTileOnTap(
                                        index: index,
                                        musicList: state.musicsList,
                                        currentMusic: music.uri,
                                        musicTitle: music.title,
                                        artistsName: music.artist,
                                        musicListLength: musicListLength,
                                        snapshotMusicList: musicList);
                                  },

                                  ///!-------  Music Icon
                                  leading: SlideInLeft(
                                    child: const Icon(
                                      EvaIcons.music,
                                      // color: Colors.white,
                                    ),
                                  ),

                                  ///!------------------  Music Title
                                  title: Text(
                                    music.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.spMax),
                                  ),

                                  ///!--------  Artists
                                  subtitle: Text(
                                    music.artist ?? "Unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11.spMax),
                                  ),

                                  ///!--------  Music Visualization
                                  trailing:
                                      themeState.localMusicSelectedTileIndex ==
                                              index
                                          ? const MiniMusicVisualizerWidget()
                                          : null,
                                ),

                                ///!-------  Search Filter Logic
                                filter: (value) => snapshot.data!
                                    .where(
                                      (music) => music.title
                                          .toLowerCase()
                                          .contains(value.trim().toLowerCase()),
                                    )
                                    .toList(),

                                ///!------  No Music Found on Searching
                                emptyWidget: const Center(
                                  child: Text("No Music Found!"),
                                ),

                                ////!---------------------  Search Field Input Decoration
                                inputDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.sp, vertical: 8.sp),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: themeState.isDarkMode
                                      ? null
                                      : Colors.grey.shade100,
                                  enabled: true,
                                  hintText: " Search",

                                  ///------ Focus Border
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                physics: const BouncingScrollPhysics(),
                                cursorColor: Color(themeState.accentColor),
                                maxLines: 1,
                                closeKeyboardWhenScrolling: true,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("No Music Found!"),
                        );
                      }
                    });
              } else if (state is FetchMusicFromLocalStorageLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(themeState.accentColor),
                  ),
                );
              } else if (state is FetchMusicFromLocalStorageFailureState) {
                return Center(
                  child: Text(state.failureMessage),
                );
              } else {
                return const Center(
                  child: Text("No Music Available"),
                );
              }
            },
          );
        },
      ),
    );
  }

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _listTileOnTap(
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
        futureMusicList: musicList,
        musicTitle: musicTitle,
        musicArtist: artistsName,
        musicListLength: musicListLength,
        snapshotMusicList: snapshotMusicList);

    ///! ------  Hide Keyboard if active
    FocusManager.instance.primaryFocus?.unfocus();

    ///!-------  Change Selected Tile Index
    context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);


    ///!-------  Save Current Playing Music Offset
    context
        .read<
        SearchableListScrollControllerCubit>()
        .updateScrollOffset(
        scrollOffset: locator
            .get<ScrollController>()
            .offset);
  }
}


