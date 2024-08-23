import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/data/models/music_model.dart';
import 'package:lofiii/logic/bloc/fetch_lofiii_music_from_internet/lofiii_music_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_music_data_to_player/now_playing_music_data_to_player_cubit.dart';
import 'package:lofiii/logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import 'package:one_context/one_context.dart';
import '../../../../../logic/bloc/player/music_player_bloc.dart';
import '../../../../../logic/cubit/lofiii_music_search_system/lofiii_music_search_system_cubit.dart';
import '../../../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../../common/mini_player_widget.dart';

class OnlineMusicSearchPage extends StatefulWidget {
  const OnlineMusicSearchPage({super.key, required this.combinedMusicList});

 final  List<MusicModel> combinedMusicList;

  @override
  State<OnlineMusicSearchPage> createState() => _OnlineMusicSearchPageState();
}

class _OnlineMusicSearchPageState extends State<OnlineMusicSearchPage> {
  late TextEditingController searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    searchController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///---------? App Bar-------------------////
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                OneContext().pop();
              },
              icon: const Icon(CupertinoIcons.back)),

          ///!----------------- Text Field----------------------///
          BlocBuilder<LofiiiMusicBloc, LofiiiMusicState>(
            builder: (context, state) => Expanded(
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  ///! Add
                  context.read<LofiiiMusicSearchSystemCubit>().searchNow(
                      val: value, combinedMusicList: widget.combinedMusicList);
                  _scrollController.jumpTo(0);
                },
                controller: searchController,
                maxLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Now",
                    hintMaxLines: 1,
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear))),
              ),
            ),
          )
        ],
      ),

      //---------?         B O D Y ------------------///
      body: Stack(
        fit: StackFit.expand,
        children: [
          ///     ------!              Filtered List
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<LofiiiMusicSearchSystemCubit,
                LofiiiMusicSearchSystemState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.filteredlist.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      ///------------!   List Tile On Pressed
                      onTap: () {
                        _playMusicMethod(state: state, index: index);
                      },

                      ///-----------! Music Title
                      title: Text(state.filteredlist[index].title),

                      ///----------!Artist Name
                      subtitle: Text(state.filteredlist[index].artists
                          .join(" & ")
                          .toString()),

                      ///-----! Image Provider
                      leading: Ink.image(
                        image: CachedNetworkImageProvider(
                          state.filteredlist[index].image,
                        ),
                        width: 0.15.sw,
                        height: 0.1.sh,
                      ),

                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50))),
                    ),
                  ),
                );
              },
            ),
          ),

          ///? Mini Player ---------////
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

  ///? ----------------- M E T H O D S----------------///
  void _playMusicMethod(
      {required index, required LofiiiMusicSearchSystemState state}) {
    final music = state.filteredlist[index];

    ///!----Initialize & Play Music ------///
    context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
        url: music.url,
        isOnlineMusic: true,
        musicAlbum: "LOFIII Music",
        musicId: music.id,
        musicTitle: music.title,
        onlineMusicThumbnail: music.image,
        offlineMusicThumbnail: null));

    ///!-----Send Current Music Data-----///
    // context
    //     .read<CurrentlyPlayingMusicDataToPlayerCubit>()
    //     .sendDataToPlayer(fullMusicList: state.filteredlist, musicIndex: index);

    context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
        musicIndex: index,
        musicList: state.filteredlist,
        musicThumbnail: state.filteredlist[index].image,
        musicTitle: state.filteredlist[index].title,
        uri: state.filteredlist[index].url,
        musicArtist: state.filteredlist[index].artists,
        musicListLength: state.filteredlist.length,
        musicId: 1);

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();
    context
        .read<YoutubeMusicPlayerCubit>()
        .disposePlayer(state: context.watch<YoutubeMusicPlayerCubit>().state);
  }
}
