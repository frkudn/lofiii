import 'package:cached_network_image/cached_network_image.dart';
import 'package:lofiii/logic/cubit/youtube_music_player/youtube_music_player_cubit.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';
import 'package:lottie/lottie.dart';
import '../../../../data/models/music_model.dart';
import '../../../../base/assets/app_assets.dart';
import '../../player/online/ui/online_player_page.dart';

class MusicCardsListWidget extends StatelessWidget {
  const MusicCardsListWidget({
    super.key,
    required this.list,
    required this.pageStorageKey,
  });
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
                      // index++;
                      final music = list[index];
                      context.read<MusicPlayerBloc>().add(
                            MusicPlayerInitializeEvent(
                              url: music.url,
                              isOnlineMusic: true,
                              musicAlbum: "LOFIII",
                              musicId: music.id,
                              musicTitle: music.title,
                              onlineMusicThumbnail: music.image,
                              offlineMusicThumbnail: null,
                              artist: music.artists.join(", ").toString(),
                            ),
                          );

                      ///!-----Show Mini Player-----///
                      context.read<ShowMiniPlayerCubit>().showMiniPlayer();
                      context
                          .read<ShowMiniPlayerCubit>()
                          .onlineMusicIsPlaying();
                      context
                          .read<ShowMiniPlayerCubit>()
                          .youtubeMusicIsNotPlaying();

                      context
                          .read<NowPlayingMusicDataToPlayerCubit>()
                          .sendDataToPlayer(
                              musicIndex: index,
                              musicList: list,
                              musicThumbnail: music.image,
                              musicTitle: music.title,
                              uri: music.url,
                              musicId: music.id,
                              musicArtist: music.artists,
                              musicListLength: list.length);

                      ///!-----Show Player Screen ----///
                      showModalBottomSheet(
                        showDragHandle: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const OnlinePlayerPage(),
                      );

                      context.read<YoutubeMusicPlayerCubit>().disposePlayer(
                          state:
                              context.watch<YoutubeMusicPlayerCubit>().state);
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
                                          color: Color(state.accentColor)
                                              .withOpacity(0.7),
                                          width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Lottie.asset(AppSvgsImages
                                            .lottieLoadingAnimation),
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
                                          child: Icon(
                                            FontAwesomeIcons.music,
                                            size: 38.spMax,
                                          )),
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
