import 'package:animated_react_button/animated_react_button.dart';
import 'package:lofiii/logic/bloc/fetch_favorite_music_from_local_storage/fetch_favorite_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/cubit/localMusicToFavorite/local_music_to_favorite_music_list_cubit.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';

class LocalPlayerFavoriteButtonWidget extends StatefulWidget {
  const LocalPlayerFavoriteButtonWidget({super.key});

  @override
  State<LocalPlayerFavoriteButtonWidget> createState() =>
      LocalPlayerFavoriteButtonWidgetState();
}

class LocalPlayerFavoriteButtonWidgetState
    extends State<LocalPlayerFavoriteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, themeState) {
      return BlocBuilder<NowPlayingMusicDataToPlayerCubit,
              NowPlayingMusicDataToPlayerState>(
          builder: (context, nowPlayingMusicState) {
        return BlocBuilder<LocalMusicToFavoriteMusicListCubit,
            LocalMusicFavoriteState>(
          builder: (context, favoriteState) {
            bool isFavorite =  favoriteState.favoriteList
                .contains(nowPlayingMusicState.musicId.toString());

            return AnimatedReactButton(
              defaultColor:
                  isFavorite ? Color(themeState.accentColor) : Colors.white12,
              reactColor: Color(themeState.accentColor),
              defaultIcon: isFavorite
                  ? FontAwesomeIcons.heartPulse
                  : FontAwesomeIcons.heart,
              showSplash: isFavorite ? false : true,
              onPressed: () {
                setState(() {
                  String musicId = nowPlayingMusicState.musicId.toString();
                  context
                      .read<LocalMusicToFavoriteMusicListCubit>()
                      .favoriteToggle(musicId: musicId);

                  context.read<FetchFavoriteMusicFromLocalStorageBloc>().add(
                      FetchFavoriteMusicFromLocalStorageInitializationEvent());
                });
              },
            );
          },
        );
      });
    });
  }
}
