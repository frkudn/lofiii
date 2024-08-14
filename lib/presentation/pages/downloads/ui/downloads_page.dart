import 'package:lofiii/base/assets/app_fonts.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../exports.dart';

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
    super.initState();
    locator.get<ScrollController>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, themeState) {
      return Scaffold(
        ///!------------ App Bar ------------///
        appBar: _appBar(),

        ///!----------  Floating Action Button ------------------///
        floatingActionButton:
            const DownloadPageNowPlayingPositionFloatingButtonWidget(),

        ///!-------------   Body ---------//
        body:

            // !/------------------  Music List -----////
            BlocBuilder<FetchMusicFromLocalStorageBloc,
                FetchMusicFromLocalStorageState>(builder: (context, state) {
          if (state is FetchMusicFromLocalStorageSuccessState) {
            return SlideInDown(
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
                    child: BlocBuilder<NowPlayingMusicDataToPlayerCubit,
                        NowPlayingMusicDataToPlayerState>(
                      builder: (context, nowPlayingState) {
                        return Scrollbar(
                          controller: locator.get<ScrollController>(),
                          child: ListView.builder(
                            // key: const PageStorageKey("downloadPageKey"),
                            physics: const ClampingScrollPhysics(),
                            itemCount: isSearching
                                ? filteredList.length
                                : state.musicsList.length,
                            controller: locator.get<ScrollController>(),
                            itemBuilder: (context, index) {
                              //---------------- Music List-------------------////
                              final SongWithArtwork music = isSearching
                                  ? filteredList[index]
                                  : state.musicsList[index];

                              bool isSelected =
                                  nowPlayingState.uri! == music.uri;

                              return ListTile(
                                selected: isSelected ? true : false,
                                selectedColor: Color(themeState.accentColor),

                                ///!-------  On Tap
                                onTap: () {
                                  _listTileOnTap(
                                      index: index,
                                      musicList: state.musicsList,
                                      musicTitle: music.title,
                                      musicThumbnail: music.artwork,
                                      artistsName: music.artist ?? "Unknown",
                                      musicListLength: state.musicsList.length,
                                      uri: music.uri,
                                      musicId: music.id,
                                      nowPlayingMusicUri: nowPlayingState.uri);
                                },

                                ///!-------  Music Icon
                                leading: SlideInLeft(
                                  child: WidgetAnimator(
                                    atRestEffect: isSelected
                                        ? WidgetRestingEffects.rotate(
                                            duration:
                                                const Duration(seconds: 15))
                                        : WidgetRestingEffects.none(),
                                    child: music.artwork != null
                                        ? Card(
                                            margin: EdgeInsets.zero,
                                            shape: const CircleBorder(),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.memory(
                                                  fit: BoxFit.cover,
                                                  height: 42.sp,
                                                  width: 42.sp,
                                                  music.artwork!),
                                            ),
                                          )
                                        : Card(
                                            margin: EdgeInsets.zero,
                                            shape: const CircleBorder(),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                  fit: BoxFit.cover,
                                                  height: 42.sp,
                                                  width: 42.sp,
                                                  AppSvgsImages
                                                      .userDefaultProfileImage),
                                            ),
                                          ),
                                  ),
                                ),

                                ///!------------------  Music Title
                                title: !isSelected
                                    ? Text(
                                        music.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: AppFonts.exo2Regular,
                                            fontSize: 15.spMax),
                                      )
                                    : TextAnimator(
                                        atRestEffect:
                                            WidgetRestingEffects.dangle(),
                                        music.title,
                                        maxLines: 6,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                AppFonts.poppinMediumItalic,
                                            fontSize: 15.spMax),
                                      ),

                                ///!--------  Artists
                                subtitle: Text(
                                  music.artist ?? "Unknown",
                                  maxLines: isSelected ? 2 : 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11.spMax),
                                ),

                                ///!--------  Music Visualization
                                trailing: isSelected
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            );

            ///-------------- If Loading --------------------///
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

  ///-----------------------------Widgets-----------------------///
  AppBar _appBar() => AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
        title: Text(
          "L o c a l  M u s i c",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        ),
        actions: [
          ///--------------- Scan Media
          IconButton(
            onPressed: () {
              context
                  .read<FetchMusicFromLocalStorageBloc>()
                  .add(FetchMusicFromLocalStorageInitializationEvent());
            },
            icon: Icon(
              FontAwesomeIcons.arrowRotateRight,
              size: 20.sp,
            ),
          ),

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
      );

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _listTileOnTap(
      {required List<SongWithArtwork> musicList,
      required int index,
      required String musicTitle,
      required Uint8List? musicThumbnail,
      required String artistsName,
      required int musicListLength,
      required String? uri,
      required int musicId,
      required String nowPlayingMusicUri}) {
    //------- Check if music particular music is already playing then just open music page
    if (uri != nowPlayingMusicUri) {
      ///!-----Play Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: uri!,
          isOnlineMusic: false,
          musicAlbum: musicList[index].album ?? "Unknown",
          musicTitle: musicTitle,
          onlineMusicThumbnail: null,
          musicId: musicId,
          offlineMusicThumbnail: musicList[index].artwork,
          artist: artistsName));
    }

    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().offlineMusicIsPlaying();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();

    //-----Show Offline Player Screen ----///
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const OfflinePlayerPage(),
    );

    if (nowPlayingMusicUri != uri!) {
      ///!---- Send Data to Offline Player
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: musicList,
          musicThumbnail: musicThumbnail,
          musicTitle: musicTitle,
          musicArtist: artistsName,
          musicListLength: musicListLength,
          uri: uri,
          musicId: musicId);
    }

    ///! ------  Hide Keyboard if active
    FocusManager.instance.primaryFocus?.unfocus();

    if (!isSearching) {
      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);

      ///!-------  Save Current Playing Music Offset
      context.read<SearchableListScrollControllerCubit>().updateScrollOffset(
          scrollOffset: locator.get<ScrollController>().offset);
    }
    context
        .read<YoutubeMusicPlayerCubit>()
        .disposePlayer(state: context.watch<YoutubeMusicPlayerCubit>().state);
  }
}

///?-------Storing/Preserve  Scroll Position
final downloadPageBucket = PageStorageBucket();
