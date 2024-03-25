import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:one_context/one_context.dart';

import '../../../data/models/music_model.dart';
import '../../../logic/bloc/favorite_button/favorite_button_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_state.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../widgets/mini_player/mini_player_widget.dart';
import '../../widgets/mysliverappbarpersistentdelegatewidget/my_sliver_appbar_persistent_delegate.dart';
import '../player/player_page.dart'; // Import this for Colors

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key, required this.artistName, required this.image});

  final String artistName;
  final String image;

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      ///!----------    AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              OneContext().pop();
            }),
      ),

      ///!-----------    Body
      body: Stack(
        fit: StackFit.expand,
        children: [
          ///--------------
          ///!--------------             C U S T O M  S C R O L L  V I E W
          ///--------------
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              ///?-----------------------------         Sliver Persistent  Header
              SliverPersistentHeader(
                delegate: MySliverAppBarPersistentDelegate(
                    imageUrl: widget.image, artistName: widget.artistName),
                pinned: true,
                floating: true,
              ),


              SliverToBoxAdapter(
                child: BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                  builder: (context, state) {
                    //?//////////////////////////////////////
                    ///! ----------   If state is Success
                    ////?///////////////////////////////////
                    if (state is LofiiiAllMusicSuccessState) {
                      ///////////////////////////////////////////////////!
                      ///! -------------  Filtered List    ----------////
                      //////////////////////////////////////////////////!

                      final List<MusicModel> filteredList = state.musicList
                          .where((element) =>
                              element.artists.first.toLowerCase().contains(
                                  widget.artistName.toString().toLowerCase()) ||
                              element.artists.last.toLowerCase().contains(
                                  widget.artistName.toString().toLowerCase()))
                          .toList();

                      ////---------- ListView Builder -----------/////
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: filteredList.length,

                        ///-------------------------------------------------------
                        ////!---------------  Music Tile  Card--------------------- ///
                        ////------------------------------------------------------
                        itemBuilder: (context, index) => ListTile(
                          ///-------------!         On Tap
                          onTap: () {
                            _listTileOnTap(context, filteredList, index);
                          },

                          ///!-----------------   Music Title
                          title: Text(
                            filteredList[index].title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),

                          ///! ------------------ Artists
                          subtitle: Text(filteredList[index]
                              .artists
                              .join(", ")
                              .toString()),

                          ///!------------------  Music Card Image
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            width: 0.1.sw,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    filteredList[index].image),
                              ),
                            ),
                          ),

                          ///!----------------------       Favorite Button Toggle  --------------///
                          trailing: BlocBuilder<FavoriteButtonBloc,
                              FavoriteButtonState>(
                            builder: (context, state) {
                              bool isFavorite = state.favoriteList
                                  .contains(filteredList[index].title);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<FavoriteButtonBloc>().add(
                                        FavoriteButtonToggleEvent(
                                            title: filteredList[index].title));
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? FontAwesomeIcons.heartPulse
                                        : FontAwesomeIcons.heart,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    //?//////////////////////////////////////
                    ///! ----------   If state is Loading
                    ////?///////////////////////////////////
                    else if (state is LofiiiAllMusicLoadingState) {
                      return SliverToBoxAdapter(
                        child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
                          builder: (context, themeState) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(themeState.accentColor),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    //?//////////////////////////////////////
                    ///! ----------   If state is not Loading nor Success
                    ////?///////////////////////////////////
                    else {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text("Something went Wrong"),
                        ),
                      );
                    }
                  },
                ),
              ),


            ],
          ),

          //--------------
          ///?--------------             Mini Player
          ///--------------
          ///!--------Show Mini Player First whenever music card is clicked
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

  ///?------------------               M E T H O D S            --------------------------///
  void _listTileOnTap(
      BuildContext context, List<MusicModel> filteredList, int index) {
    ///!----Initialize & Play Music ------///
    context
        .read<MusicPlayerBloc>()
        .add(MusicPlayerInitializeEvent(url: filteredList[index].url));

    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();

    ///!-----Send Current Music Data-----///
    context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
        musicIndex: index,
        imageUrl: filteredList[index].image.toString(),
        fullMusicList: filteredList);

    ///!-----Show Player Screen ----///
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const PlayerPage(),
    );
  }
}
