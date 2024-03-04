import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


import '../../../data/models/music_model.dart';
import '../../../logic/bloc/favorite_button/favorite_button_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../../logic/bloc/lofiii_all_music/lofiii_all_music_state.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../resources/spinkit_animation_indicators/spinkit_indicators.dart';
import '../../widgets/mini_player/mini_player_widget.dart';
import '../../widgets/mysliverappbarpersistentdelegatewidget/my_sliver_appbar_persistent_delegate.dart';
import '../player/player_page.dart'; // Import this for Colors

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key, required this.artistName, required this.image})
      : super(key: key);

  final String artistName;
  final String image;

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
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
              Navigator.pop(context);
            }),
      ),

      ///!-----------    Body
      body: Stack(
        children: [

          ///--------------
          ///!--------------             C U S T O M  S C R O L L  V I E W
          ///--------------
          CustomScrollView(
            slivers: [
              ///?-----------------------------         Sliver Persistent  Header
              SliverPersistentHeader(
                delegate: MySliverAppBarPersistentDelegate(
                    imageUrl: widget.image, artistName: widget.artistName),
                pinned: true,
                floating: true,
              ),

              SliverToBoxAdapter(
                child: Gap(0.01.sh),
              ),
              
              ///?-----------------------------           Artist Music List
              SliverToBoxAdapter(
                child: ShrinkWrappingViewport(
                  offset: ViewportOffset.zero(),
                  slivers: [
                    BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                      builder: (context, state) {
                        ///! ---------  All Music State is Success
                        if (state is LofiiiAllMusicSuccessState) {
                          ///! -------------  Filtered List    ----------////
                          final List<MusicModel> filteredList = state.musicList
                              .where((element) =>
                                  element.artists.first.toLowerCase().contains(
                                      widget.artistName.toString().toLowerCase()) ||
                                  element.artists.last.toLowerCase().contains(
                                      widget.artistName.toString().toLowerCase()))
                              .toList();

                          ///?//////////////////////////////////////////////////////

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              ///--------!      List Tile
                              (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: ListTile(
                                  ///-------------!         On Tap
                                  onTap: () {
                                    _listTileOnTap(context, filteredList, index);
                                  },

                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                  contentPadding: const EdgeInsets.all(3),

                                  ///!------------------  Music Card Image
                                  leading: Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: 0.1.sw,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(filteredList[index].image),
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///!-----------------   Music Title
                                  title: Text(
                                    filteredList[index].title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),

                                  ///! ------------------ Artists
                                  subtitle: Text(filteredList[index]
                                      .artists
                                      .join(", ")
                                      .toString()),

                                  ///!----------------------       Favorite Button Toggle  --------------///
                                  trailing: BlocBuilder<FavoriteButtonBloc,
                                      FavoriteButtonState>(
                                    builder: (context, state) {
                                      bool isFavorite = state.favoriteList
                                          .contains(filteredList[index].title);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: IconButton(
                                          onPressed: () {
                                            context.read<FavoriteButtonBloc>().add(
                                                FavoriteButtonToggleEvent(
                                                    title:
                                                        filteredList[index].title));
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            isFavorite
                                                ? CupertinoIcons.heart_fill
                                                : CupertinoIcons.heart,
                                            color: Theme.of(context).textTheme.bodyMedium!.color,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // tileColor: colors[index],
                                ),
                              ),

                              ///!--------------  Artists Music Length
                              childCount: filteredList.length,
                            ),
                          );
                        }

                        ///! ----------   If state is Loading
                        else if (state is LofiiiAllMusicLoadingState) {
                          return   const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        ///! -----------   Else
                        else {
                          return const SliverToBoxAdapter(
                            child: Center(
                              child: Text("Something went Wrong"),
                            ),
                          );
                        }
                      },
                    ),

                   ///!----- Extra Bottom Space
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 0.1.sh,
                      ),
                    )


                  ],
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
  void _listTileOnTap(BuildContext context, List<MusicModel> filteredList, int index) {
      ///!----Initialize & Play Music ------///
    context.read<MusicPlayerBloc>().add(
        MusicPlayerInitializeEvent(url: filteredList[index].url));
    
    ///!-----Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    
    ///!-----Send Current Music Data-----///
    context
        .read<CurrentlyPlayingMusicDataToPlayerCubit>()
        .sendDataToPlayer(
        musicIndex: index,
        imageUrl: filteredList[index].image.toString(),
    fullMusicList: filteredList
    );
    
    ///!-----Show Player Screen ----///
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const PlayerPage(),
    );
  }
}
