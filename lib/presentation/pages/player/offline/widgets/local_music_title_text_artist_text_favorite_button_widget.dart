import 'package:flutter/cupertino.dart';
import 'package:lofiii/presentation/pages/player/exports.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_player_favorite_button_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_player_music_artist_widget.dart';
import 'package:lofiii/presentation/pages/player/offline/widgets/local_player_music_title_widget.dart';

class LocalMusicTitleTextArtistTextFavoriteButtonWidget
    extends StatelessWidget {
  const LocalMusicTitleTextArtistTextFavoriteButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 0.08.sh,
          width: 0.8.sw,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///------ Music Title-------------///
              Flexible(
                child: LocalPlayerMusicTitleWidget(),
              ),

              //-----------   Favorite Button -------------------//
              LocalPlayerFavoriteButtonWidget(),
            ],
          ),
        ),

        //--------- Music Artist----------///
        const LocalPlayerMusicArtistWidget(),
      ],
    );
  }
}
