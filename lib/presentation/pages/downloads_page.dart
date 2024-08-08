import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:lofiii/presentation/pages/player/offline_player_page.dart';
import 'package:lofiii/presentation/widgets/more_music_button_widget.dart';
import 'package:lofiii/presentation/widgets/music_cards_list/music_cards_list_widget.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

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
  List filteredList = [];
  bool isSearching = false;

  int musicListSorting = 0;

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
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, themeState) {
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
          actions: [
            ///------------- Search Button
            IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) filteredList.clear();
                });
              },
              icon: const Icon(Icons.search),
            ),

            const Gap(10),
          ],
        ),

        ///!----------  Floating Action Button ------------------///
        floatingActionButton: const NowPlayingPositionFloatingButtonWidget(),

        ///!-------------   Body ---------//
        body:

            // !/------------------  Music List -----////
            BlocBuilder<FetchMusicFromLocalStorageBloc,
                FetchMusicFromLocalStorageState>(builder: (context, state) {
          if (state is FetchMusicFromLocalStorageSuccessState) {
            return PageStorage(
              bucket: pageBucket,

              ///!-------- Animation ------///
              child: SlideInDown(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///--------------------- Search Field ---------------------///
                    if (isSearching)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: Color(themeState.accentColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          autofocus: isSearching,
                          cursorOpacityAnimates: true,
                          maxLines: 1,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (val) {
                            setState(() {
                              filteredList = state.musicsList.where(
                                (element) {
                                  return element.displayName
                                          .toLowerCase()
                                          .contains(val.toLowerCase()) ||
                                      element.artist!
                                          .toLowerCase()
                                          .contains(val.toLowerCase());
                                },
                              ).toList();
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                    filteredList.clear();
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              ),
                              hintText: "  Search eg. title, artist"),
                        ),
                      ),

                    ///-------------------- Music List --------------///
                    Expanded(
                      child: ListView.builder(
                        itemCount: isSearching
                            ? filteredList.length
                            : state.musicsList.length,
                        controller: locator.get<ScrollController>(),
                        itemBuilder: (context, index) {
                          final music = isSearching
                              ? filteredList[index]
                              : state.musicsList[index];

                          bool isSelected = !isSearching
                              ? themeState.localMusicSelectedTileIndex == index
                              : false;

                          return ListTile(
                            selected: isSelected ? true : false,
                            selectedColor: Color(themeState.accentColor),

                            ///!-------  On Tap
                            onTap: () {
                              _listTileOnTap(
                                index: index,
                                musicList: state.musicsList,
                                currentMusic: music.uri,
                                musicTitle: music.title,
                                artistsName: music.artist,
                                musicListLength: state.musicsList.length,
                              );
                            },

                            ///!-------  Music Icon
                            leading: SlideInLeft(
                              child: const Icon(
                                EvaIcons.music,
                                // color: Colors.white,
                              ),
                            ),

                            ///!------------------  Music Title
                            title: !isSelected
                                ? Text(
                                    music.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.spMax),
                                  )
                                : TextAnimator(
                                    atRestEffect:
                                        WidgetRestingEffects.wave(),
                                    music.title,
                                    maxLines: 6,
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
                            trailing: isSearching
                                ? null
                                : themeState.localMusicSelectedTileIndex ==
                                        index
                                    ?

                                    ///---------- Music mini Visualization
                                    const MiniMusicVisualizerWidget()
                                    :

                                    ///---------------- More Info Button --------
                                    MoreMusicButtonWidget(
                                        song: music,
                                      ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
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
            return Center(
              child: TextAnimator(
                  atRestEffect: WidgetRestingEffects.rotate(),
                  "No Music Available"),
            );
          }
        }),
      );
    });
  }

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _listTileOnTap({
    required musicList,
    required index,
    currentMusic,
    required musicTitle,
    required artistsName,
    required musicListLength,
  }) {
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

    ///! ------  Hide Keyboard if active
    FocusManager.instance.primaryFocus?.unfocus();
    if (!isSearching) {
      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);

      ///!-------  Save Current Playing Music Offset
      context.read<SearchableListScrollControllerCubit>().updateScrollOffset(
          scrollOffset: locator.get<ScrollController>().offset);
    }
  }
}
