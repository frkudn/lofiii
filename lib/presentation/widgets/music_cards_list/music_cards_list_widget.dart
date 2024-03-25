import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/music_model.dart';
import '../../../logic/bloc/player/music_player_bloc.dart';
import '../../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/my_assets/my_assets.dart';
import '../../pages/player/player_page.dart';

class MusicCardsListWidget extends StatelessWidget {
  const MusicCardsListWidget({super.key, required this.list, required this.pageStorageKey,});
final String pageStorageKey;
  final List<MusicModel> list;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        // color: Colors.amber,
        height: 0.30.sh,
        width: double.infinity,
        child: FadeInDown(
          ///!     -------Storing/Preserve  Scroll Position
          child: PageStorage(
            bucket: pageBucket,
            child: ListView.builder(
                key: PageStorageKey(pageStorageKey),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),

                ///------------Total Items-------///
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    ///-------------------------------------?Music Card On Tap
                    onTap: () {
                      ///!----Initialize & Play Music ------///
                      context.read<MusicPlayerBloc>().add(
                          MusicPlayerInitializeEvent(url: list[index].url));

                      ///!-----Show Mini Player-----///
                      context.read<ShowMiniPlayerCubit>().showMiniPlayer();
                      context.read<ShowMiniPlayerCubit>().onlineMusicIsPlaying();
                      context.read<ShowMiniPlayerCubit>().youtubeMusicIsNotPlaying();

                      ///!-----Send Current Music Data-----///
                      context
                          .read<CurrentlyPlayingMusicDataToPlayerCubit>()
                          .sendDataToPlayer(
                              musicIndex: index,
                              imageUrl: list[index].image.toString(),
                              fullMusicList: list);

                      ///!-----Show Player Screen ----///
                      showModalBottomSheet(
                        showDragHandle: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const PlayerPage(),
                      );
                    },
                    child: BounceInRight(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///!----------Cached Network Image--------///
                          CachedNetworkImage(
                            ///!--------Music Image Url List-------///
                            imageUrl: list[index].image.toString(),
                      
                            ///!-------On Image Successfully Loaded---------///
                            imageBuilder: (context, imageProvider) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                surfaceTintColor: Colors.transparent,
                                color: Colors.transparent,
                                margin: EdgeInsets.zero,
                                child: Container(
                                  height: 0.25.sh,
                                  width: 0.35.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      
                            ///!----------------On Loading-------------///
                            placeholder: (context, url) =>
                                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 0.25.sh,
                                    width: 0.35.sw,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color(state.accentColor).withOpacity(0.7),
                                          width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Lottie.asset(MyAssets.lottieLoadingAnimation),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      
                            ///!----------------On Error-------------///
                            errorWidget: (context, url, error) =>
                                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 0.25.sh,
                                    width: 0.35.sw,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Color(state.accentColor),
                                          width: 2),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(FontAwesomeIcons.music, size: 38.spMax,)
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      
                          ///--------?             Music  Title         ----------///
                          SizedBox(
                            ///Set The Text Width as Image Width
                            width: 0.35.sw,
                            child: Text(
                              list[index].title,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 8.sp, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

///?-------Storing/Preserve  Scroll Position
final pageBucket = PageStorageBucket();
