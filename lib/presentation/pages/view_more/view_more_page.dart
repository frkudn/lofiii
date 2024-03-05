import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/gridview_max_count/gridview_max_cout_cubit.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../widgets/mini_player/mini_player_widget.dart';

class ViewMorePage extends StatefulWidget {
  const ViewMorePage({
    super.key, required this.topHeading,
    required this.musicList,
  });




  final String topHeading;
  final musicList;

  @override
  State<ViewMorePage> createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(CupertinoIcons.back)),
        title: Text(widget.topHeading,),
        actions: [
          IconButton(onPressed: () {
            context.read<GridviewMaxCountCubit>().changeMaxCount();
          }, icon: BlocBuilder<GridviewMaxCountCubit, GridviewMaxCountState>(
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
      body: Stack(
        children: [
          ///? Music List --------------------///
        BlocBuilder<GridviewMaxCountCubit,
        GridviewMaxCountState>(
        builder: (context, maxCountState) {
          return Expanded(
            child: FadeInDownBig(
              child: GridView.builder(
                  padding: EdgeInsets.all(5.spMax),
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
                    onTap: (){
                      playMusicMethod(index, context, widget.musicList);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///----!Image
                        Flexible(

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(

                                onError: (exception, stackTrace) => const Center(child: Icon(FontAwesomeIcons.music),),
                                image: CachedNetworkImageProvider(
                                    widget.musicList[index].image, ),
                              ),
                            ),
                          ),
                        ),

                        Gap(0.01.sh),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.musicList[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: maxCountState.maxCount == 1
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

                        Gap(0.005.sh)
                      ],
                    ),
                  )),
            ),
          );
        },
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
  void playMusicMethod(
      int index, BuildContext context, musicList) {
    ///!---------      Initialize & Play Music ------///
    context
        .read<MusicPlayerBloc>()
        .add(MusicPlayerInitializeEvent(url: musicList[index].url));

    ///!-----       Send Current Music Data-----///
    context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
        musicIndex: index,
        imageUrl: musicList[index].image.toString(),
    fullMusicList: musicList,

    );

    ///!-----        Show Mini Player-----///
    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
  }
}
