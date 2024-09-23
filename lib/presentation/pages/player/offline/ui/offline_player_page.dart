import 'package:flutter/cupertino.dart';
import 'package:lofiii/presentation/pages/home/exports.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_background_image_filter_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_bottom_glass_gradient_box_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_player_volume_gesture_a_n_d_music_play_pause_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_player_music_thumbnail_widget.dart';
import '../../exports.dart';

class OfflinePlayerPage extends StatefulWidget {
  const OfflinePlayerPage({
    super.key,
  });

  @override
  State<OfflinePlayerPage> createState() => _OfflinePlayerPageState();
}

class _OfflinePlayerPageState extends State<OfflinePlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state is MusicPlayerSuccessState) {
            return BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, themeState) {
                return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
                    NowPlayingMusicDataToPlayerState>(
                  builder: (context, nowPlayingMusicState) {
                    return Stack(
                      children: [
                        //!------------------------------------------------------------------------------------------///
                        ///?--------------------        Background Gradient Colors Section   --------------------///
                        ///------------------------------------------------------------------------------------------///
                        ///---  Back
                        const OfflinePlayerBackgroundGradientBoxesWidget(),

                        ///?--------------------        Background Blur Image Section   --------------------///
                        if (nowPlayingMusicState.musicThumbnail != null)
                          const LocalMusicBackgroundImageFilterWidget(),

                        ///----------------------------   Background Blur Image -----------------------///

                        ///!------- Music Icon -----///
                        if (nowPlayingMusicState.musicThumbnail == null)
                          ZoomIn(
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.music,
                                color: Colors.white,
                                size: 50.spMax,
                              ),
                            ),
                          ),

                        ///!------------------------------  M U S I C  T H U M B N A I L ------------------------////
                        if (nowPlayingMusicState.musicThumbnail != null)
                          const LocalPlayerMusicThumbnailWidget(),

                        ///--------------------------------------------------------------------------///
                        ///!------------------------  Volume & Play Pause Gesture  ----------------///
                        ///--------------------------------------------------------------------------///
                        const LocalMusicPlayerVolumeGestureANDMusicPlayPauseWidget(),

                        ///!-------------  Glass Gradient Box ---------///
                        const LocalMusicBottomGlassGradientBoxWidget(),
                      ],
                    );
                  },
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  ///--------------------------------------------------------------------------------///
  ///-------------------?             W I D G E T S  --------------------///
  ///!--------------------------------------------------------------------------------///
  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          color: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 30.sp,
          )),

      automaticallyImplyLeading: false,

      ///!-----      Drag Handle    ----///
      title: SlideInUp(child: myCustomDragHandle),
      centerTitle: true,
      toolbarHeight: 0.15.sh,

      actions: [
        ///!-----      More Options    ----///
        IconButton(
            color: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: const [
                      
                        ListTile(
                          trailing: Icon(Icons.playlist_add),
                          title: Text(
                            "Add to Playlist",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.info),
                          title: Text(
                            "Info",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.lyrics),
                          title: Text(
                            "Lyrics",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.speed),
                          title: Text(
                            "Change Speed",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(FontAwesomeIcons.bed),
                          title: Text(
                            "Sleep",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.call),
                          title: Text(
                            "Set as Ringtone",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(FontAwesomeIcons.pencil),
                          title: Text(
                            "Rename",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.delete),
                          title: Text(
                            "Delete",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert))
      ],
    );
  }
}
