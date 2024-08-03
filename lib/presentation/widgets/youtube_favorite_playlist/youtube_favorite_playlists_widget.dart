import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../logic/cubit/youtube_music/youtube_music_cubit.dart';
import '../../../resources/my_assets/my_assets.dart';
import '../../pages/youtube_music/youtube_favorite_playlist_page.dart';

///!-------------- Youtube Favorite Playlist --------------//
class YoutubeFavoritePlaylistWidget extends StatelessWidget {
  const YoutubeFavoritePlaylistWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.57.sh,
      width: 1.sw,
      child: BlocBuilder<YoutubeMusicCubit, YoutubeMusicState>(
        builder: (context, ytState) {
          if (ytState is YoutubeMusicSuccessState) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: ytState.favoriteFuturePlayLists.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // Navigate to the YouTube favorite playlist page.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YouTubeFavoritePlaylistPage(
                        // Pass playlist information to the page.
                        musicList: ytState.favoriteFuturePlayLists[index],
                        playlistThumbnail: _favoritePlaylists[index].photo,
                        playlistTitle: _favoritePlaylists[index].title,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //!------------------- Music thumbnail section
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _favoritePlaylists[index].photo,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          useOldImageOnUrlChange: true,
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
                                height: 0.23.sh,
                                width: 0.45.sw,
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
                          // Placeholder widget when image is loading
                          placeholder: (context, url) =>
                              _buildLoadingPlaceholder(context),
                          // Error widget when image loading fails
                          errorWidget: (context, url, error) =>
                              _buildErrorWidget(context),
                        ),
                        // Play icon positioned at the bottom-right corner
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: _buildPlayIcon(context),
                        ),
                      ],
                    ),
                    // Music title
                    Text(
                      _favoritePlaylists[index].title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                ),
              ),
            );
          } else {
            // Show a loading indicator when data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Builds a loading placeholder widget
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 0.23.sh,
        width: 0.45.sw,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(
              BlocProvider.of<ThemeModeCubit>(context).state.accentColor,
            ).withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Lottie.asset(MyAssets.lottieLoadingAnimation),
          ),
        ),
      ),
    );
  }

  // Builds an error widget
  Widget _buildErrorWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 0.23.sh,
        width: 0.45.sw,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(
              BlocProvider.of<ThemeModeCubit>(context).state.accentColor,
            ),
            width: 2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              FontAwesomeIcons.music,
              size: 38.spMax,
            ),
          ),
        ),
      ),
    );
  }

  // Builds a play icon
  Widget _buildPlayIcon(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return CircleAvatar(
          radius: 17.sp,
          backgroundColor: themeState.isDarkMode
              ? Colors.white.withOpacity(0.8)
              : Colors.black,
          child: Icon(
            Icons.playlist_play,
            color: themeState.isDarkMode ? Colors.black : Colors.white,
          ),
        );
      },
    );
  }
}

////!-------------------------------------- Favorite List Thumbnail and Title ------------------------///
List<_FavoritePlayList> _favoritePlaylists = [
  _FavoritePlayList("Bollywood Lofi",
      "https://images.pexels.com/photos/2204724/pexels-photo-2204724.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Mashups By Gravero",
      "https://images.pexels.com/photos/5581639/pexels-photo-5581639.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Aftermorning Revolved",
      "https://images.pexels.com/photos/5581778/pexels-photo-5581778.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Fasetya Favorite",
      "https://vinyl.lofirecords.com/cdn/shop/files/1.png?v=1708526917"),
  _FavoritePlayList("Fasetya Mix",
      "https://images.pexels.com/photos/8467429/pexels-photo-8467429.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Aelo Lofi",
      "https://images.pexels.com/photos/2701236/pexels-photo-2701236.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("eternaL Lofi",
      "https://images.pexels.com/photos/16446073/pexels-photo-16446073/free-photo-of-woman-in-casual-clothing-sitting-by-the-water.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Bollywood Chill",
      "https://images.pexels.com/photos/5581744/pexels-photo-5581744.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("Saregama LofiMix",
      "https://images.pexels.com/photos/2690323/pexels-photo-2690323.jpeg?auto=compress&cs=tinysrgb&w=800"),
  _FavoritePlayList("T-Series LofiMix",
      "https://images.pexels.com/photos/3497985/pexels-photo-3497985.jpeg?auto=compress&cs=tinysrgb&w=800"),
];

class _FavoritePlayList {
  _FavoritePlayList(this.title, this.photo);
  String title;
  String photo;
}
