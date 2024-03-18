import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/presentation/pages/view_more/view_more_page.dart';
import 'package:lottie/lottie.dart';
import 'package:one_context/one_context.dart';

import '../../logic/bloc/favorite_button/favorite_button_bloc.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_state.dart';
import '../../resources/my_assets/my_assets.dart';
import '../widgets/heading_with_view_more_button/heading_with_view_more_button_widget.dart';
import '../widgets/music_cards_list/music_cards_list_widget.dart';
import '../widgets/lottie_animation/no_internet_lottie_animation_widget.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Library",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ///!-   --------------       My Favorite
          BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
            builder: (context, favoriteState) {
              return BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                builder: (context, state) {
                  //! Heading with View More Button Widget
                  return HeadingWithViewMoreButton(
                    heading: "My Favorite ❤️",
                    viewMoreOnTap: () {
                      if (state is LofiiiAllMusicSuccessState) {
                        //! Filter the favorite list
                        final favoriteList = state.musicList
                            .where((element) => favoriteState.favoriteList
                                .contains(element.title))
                            .toList();
                        //! Navigate to View More Page with filtered list
                        OneContext().push(
                          MaterialPageRoute(
                            builder: (context) => ViewMorePage(
                              topHeading: "My Favorite ❤️",
                              musicList: favoriteList,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),

          ///!       -------------Favorite List
          BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
            builder: (context, favoriteState) {
              return BlocBuilder<LofiiiAllMusicBloc, LofiiiAllMusicState>(
                builder: (context, state) {
                  ///?------------        If  Success State
                  if (state is LofiiiAllMusicSuccessState) {
                    //!  Filter the favorite list
                    final favoriteList = state.musicList
                        .where((element) =>
                            favoriteState.favoriteList.contains(element.title))
                        .toList();

                    if (favoriteList.isNotEmpty) {
                      //!  Display the filtered favorite list using MusicCardsListWidget
                      return MusicCardsListWidget(
                        list: favoriteList,
                        pageStorageKey: "favoriteStorageKey",
                      );
                    }

                    ///!-------   If Favorite list is Empty
                    else {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.30.sh,
                          width: double.infinity,
                          child: const Center(
                            child: Text("No Favorite Items available"),
                          ),
                        ),
                      );
                    }
                  }
                  //?-----------            If Loading State
                  else if (state is LofiiiAllMusicLoadingState) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 0.30.sh,
                        child: Center(
                          child: Lottie.asset(MyAssets.lottieLoadingAnimation,
                              width: 0.2.sw),
                        ),
                      ),
                    );
                  }
                  //?-----------              If failure State
                  else {
                    return const SliverToBoxAdapter(
                        child: NoInternetLottieAnimation());
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
