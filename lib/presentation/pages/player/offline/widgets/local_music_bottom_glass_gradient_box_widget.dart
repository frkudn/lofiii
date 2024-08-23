import 'package:flutter/material.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_player_buttons_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_player_position_and_duration_row_text_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_player_slider_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_music_title_text_artist_text_favorite_button_widget.dart';

class LocalMusicBottomGlassGradientBoxWidget extends StatelessWidget {
  const LocalMusicBottomGlassGradientBoxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.05.sh,
      width: 1.sw,
      child: SlideInUp(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 0.05.sw,
            vertical: 0.02.sh,
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.04.sw),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1,
                  spreadRadius: 0.5,
                  blurStyle: BlurStyle.outer,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///!      ---------------Music Title  & Artist & Favorite Button----///
              SlideInRight(
                child:
                    const LocalMusicTitleTextArtistTextFavoriteButtonWidget(),
              ),

              ///!------------------   Slider & Buttons
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ////!---------------  Slider ----------////
                  LocalMusicPlayerSliderWidget(),

                  ////!---------------    Position  & Duration  -----///
                  LocalMusicPlayerPositionAndDurationRowTextWidget(),

                  ///-------------------------------------------------------------///
                  ///!---------------------------    Player Buttons      -------///
                  ///?------------------------------------------------------------------///
                  LocalMusicPlayerButtonsWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
