import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_state.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/search_system/search_system_cubit.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../widgets/mini_player/mini_player_widget.dart';

class GlobalMusicSearchPage extends StatefulWidget {
  const GlobalMusicSearchPage({super.key});

  @override
  State<GlobalMusicSearchPage> createState() => _GlobalMusicSearchPageState();
}

class _GlobalMusicSearchPageState extends State<GlobalMusicSearchPage> {
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
          BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
            builder: (context, state) => Expanded(
              child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      if (state is LofiiiAllMusicSuccessState) {
                        context.read<SearchSystemCubit>().addSearchList(allMusicList: state.musicList);
                      }
                      ///! Add
                      context.read<SearchSystemCubit>().searchNow(val: value);
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
            child: BlocBuilder<SearchSystemCubit, SearchSystemState>(
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
                        _playMusicMethod(state: state,  index: index);
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
  void _playMusicMethod({required index,required SearchSystemState state}) {
    ///!----Initialize & Play Music ------///
    context
        .read<MusicPlayerBloc>()
        .add(MusicPlayerInitializeEvent(url: state.filteredlist[index].url));

    ///!-----Send Current Music Data-----///
    context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
    fullMusicList: state.filteredlist,
      musicIndex: index
    );

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();
  }
}
