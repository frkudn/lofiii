import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/presentation/pages/view_more/view_more_page.dart';
import 'package:lottie/lottie.dart';
import 'package:one_context/one_context.dart';
import '../../logic/bloc/artists_data/artists_data_bloc.dart';
import '../../logic/bloc/artists_data/artists_data_event.dart';
import '../../logic/bloc/artists_data/artists_data_state.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_bloc.dart';
import '../../logic/bloc/lofiii_all_music/lofiii_all_music_event.dart';
import '../../logic/bloc/lofiii_popular_music/lofiii_popular_music_bloc.dart';
import '../../logic/bloc/lofiii_special_music/lofiii_special_music_bloc.dart';
import '../../logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_bloc.dart';
import '../../logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_event.dart';
import '../../logic/bloc/lofiii_top_picks_music/lofi_top_picks_music_state.dart';
import '../../logic/bloc/lofiii_vibes_music/lofiii_vibes_music_bloc.dart';
import '../../logic/bloc/lofiii_vibes_music/lofiii_vibes_music_event.dart';
import '../../logic/bloc/lofiii_vibes_music/lofiii_vibes_music_state.dart';
import '../../resources/my_assets/my_assets.dart';
import '../widgets/artists_circle_avatar_list/artists_circle_cards_list_widget.dart';
import '../widgets/heading_with_view_more_button/heading_with_view_more_button_widget.dart';
import '../widgets/home_page_app_bar/home_app_bar.dart';
import '../widgets/music_cards_list/music_cards_list_widget.dart';
import '../widgets/lottie_animation/no_internet_lottie_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefreshMethod,

        ///!     -------Storing/Preserve  Scroll Position
        child: PageStorage(
          bucket: pageBucket,
          child: CustomScrollView(
            key: const PageStorageKey("homePageStorageKey"),
            slivers: [
              ///?-------------------------App Bar ----------------------///
              const HomePageSliverAppBar(),

              ///?-------AppBar Bottom Padding
              SliverPadding(padding: EdgeInsets.only(bottom: 20.h)),

              ///?----------------------Special Section----------------------///

              ///!-   --------------       Special Heading
              BlocBuilder<LofiiiSpecialMusicBloc, LofiiiSpecialMusicState>(
                builder: (context, state) {
                  return HeadingWithViewMoreButton(
                      heading: "LOFIII Special",
                      viewMoreOnTap: () {
                        if (state is LofiiiSpecialMusicSuccessState) {
                          OneContext().push(
                            MaterialPageRoute(
                              builder: (context) => ViewMorePage(
                                topHeading: "LOFIII Special",
                                musicList: state.musicList,
                              ),
                            ),
                          );
                        }
                      });
                },
              ),

              ///! ---------------       Special  Music List   ---------------///
              BlocBuilder<LofiiiSpecialMusicBloc, LofiiiSpecialMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiSpecialMusicSuccessState) {
                    if (state.musicList.isNotEmpty) {
                      return MusicCardsListWidget(
                        list: state.musicList,
                        pageStorageKey: "specialStorageKey",
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.4.sh,
                          child: const Center(
                              child: Text(
                                  "Something went wrong, refresh the page")),
                        ),
                      );
                    }

                    //!-----    LofiiiSpecialMusicLoadingState
                  } else if (state is LofiiiSpecialMusicLoadingState) {
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
                  //? ---- Music State is Failure State
                  else {
                    return const SliverToBoxAdapter(
                      child: NoInternetLottieAnimation(),
                    );
                  }
                },
              ),

              ///?----------------------Lo-fi Popular Section----------------------///
              ///! --------------------------      Popular    Heading
              BlocBuilder<LofiiiPopularMusicBloc, LofiiiPopularMusicState>(
                builder: (context, state) {
                  return HeadingWithViewMoreButton(
                      heading: "LOFIII Popular",
                      viewMoreOnTap: () {
                        if (state is LofiiiPopularMusicSuccessState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMorePage(
                                topHeading: "LOFIII Popular",
                                musicList: state.musicList,
                              ),
                            ),
                          );
                        }
                      });
                },
              ),

              ///! ----------------------------       Popular  Music List      --------------//////
              BlocBuilder<LofiiiPopularMusicBloc, LofiiiPopularMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiPopularMusicSuccessState) {
                    if (state.musicList.isNotEmpty) {
                      return MusicCardsListWidget(
                        list: state.musicList,
                        pageStorageKey: "popularStorageKey",
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.4.sh,
                          child: const Center(
                              child: Text(
                                  "Something went wrong, refresh the page")),
                        ),
                      );
                    }
                  } else if (state is LofiiiPopularMusicLoadingState) {
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
                  //? ----   Music State is Failure State
                  else {
                    return const SliverToBoxAdapter(
                      child: NoInternetLottieAnimation(),
                    );
                  }
                },
              ),

              ///?------------------           Artists Section      ------------------///
              ///
              ///!Heading
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Top Artists",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        letterSpacing: 1,
                    fontFamily: "Poppins"
                    ),
                  ),
                ),
              ),

              BlocBuilder<ArtistsDataBloc, ArtistsDataState>(
                builder: (context, state) {
                  ///!------------     If Success
                  if (state is ArtistsDataSuccessState) {
                    if (state.artistList.isNotEmpty) {
                      return ArtistsCardsListWidget(
                        artistList: state.artistList,
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.2.sh,
                          child: const Center(
                              child: Text(
                                  "Something went wrong, refresh the page")),
                        ),
                      );
                    }
                  }

                  ///!---------------     If Loading
                  else if (state is ArtistsDataLoadingState) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 0.2.sh,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Lottie.asset(MyAssets.lottieLoadingAnimation,
                                width: 0.2.sw),
                          ),
                        ),
                      ),
                    );
                  }

                  ///!--------   If No Internet Or Server Error
                  else {
                    return const SliverToBoxAdapter(
                      child: NoInternetLottieAnimation(),
                    );
                  }
                },
              ),

              ///?----------------------       TopPicks Section        ----------------------///

              ///! --------------------------      TopPicks    Heading
              BlocBuilder<LofiiiTopPicksMusicBloc, LofiiiTopPicksMusicState>(
                builder: (context, state) {
                  return HeadingWithViewMoreButton(
                      heading: "LOFIII TopPicks",
                      viewMoreOnTap: () {
                        if (state is LofiiiTopPicksMusicSuccessState) {
                          OneContext().push(
                            MaterialPageRoute(
                              builder: (context) => ViewMorePage(
                                topHeading: "LOFIII TopPicks",
                                musicList: state.musicList,
                              ),
                            ),
                          );
                        }
                      });
                },
              ),

              ///! ----------------------------       TopPicks  Music List      --------------//////
              BlocBuilder<LofiiiTopPicksMusicBloc, LofiiiTopPicksMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiTopPicksMusicSuccessState) {
                    if (state.musicList.isEmpty) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.4.sh,
                          child: const Center(
                              child: Text(
                                  "Something went wrong, refresh the page")),
                        ),
                      );
                    }
                    return MusicCardsListWidget(
                      list: state.musicList,
                      pageStorageKey: "topPicksStorageKey",
                    );
                  } else if (state is LofiiiTopPicksMusicLoadingState) {
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
                  //? ----       Music State is Failure State
                  else {
                    return const SliverToBoxAdapter(
                      child: NoInternetLottieAnimation(),
                    );
                  }
                },
              ),

              ///-------------------------------------------------------------------------///
              ///?----------------------Lo-fi Vibes Section----------------------///
              ///! --------------------------      Vibes    Heading
              BlocBuilder<LofiiiVibesMusicBloc, LofiiiVibesMusicState>(
                builder: (context, state) {
                  return HeadingWithViewMoreButton(
                      heading: "LOFIII Vibes",
                      viewMoreOnTap: () {
                        if (state is LofiiiVibesMusicSuccessState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMorePage(
                                topHeading: "LOFIII Vibes",
                                musicList: state.musicList,
                              ),
                            ),
                          );
                        }
                      });
                },
              ),

              ///! ----------------------------       Vibes  Music List      --------------//////
              BlocBuilder<LofiiiVibesMusicBloc, LofiiiVibesMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiVibesMusicSuccessState) {
                    if (state.musicList.isNotEmpty) {
                      return MusicCardsListWidget(
                        list: state.musicList,
                        pageStorageKey: "vibesStorageKey",
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 0.4.sh,
                          child: const Center(
                              child: Text(
                                  "Something went wrong, refresh the page")),
                        ),
                      );
                    }
                  } else if (state is LofiiiVibesMusicLoadingState) {
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
                  //? ----   Music State is Failure State
                  else {
                    return const SliverToBoxAdapter(
                      child: NoInternetLottieAnimation(),
                    );
                  }
                },
              ),

              ///!-------------------------------------------------------------------------///

              ///?------     Extra Sized Box
              SliverToBoxAdapter(
                child: Gap(
                  0.15.sh,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///?---------------------------- M E T H O D S --------------------///
  Future<void> _onRefreshMethod() async {
    ///!-----------Refresh LOFIII Special Music --------------///
    context.read<LofiiiSpecialMusicBloc>().add(LOFIIISpecialMusicFetchEvent());

    ///!-----------Refresh LOFIII Popular Music --------------///
    context.read<LofiiiPopularMusicBloc>().add(LOFIIIPopularMusicFetchEvent());

    ///!-----------Refresh LOFIII Top Picks Music --------------///
    context
        .read<LofiiiTopPicksMusicBloc>()
        .add(LOFIIITopPicksMusicFetchEvent());

    ///!-----------Refresh LOFIII All Music --------------///
    context.read<LofiiiAllMusicBloc>().add(LOFIIIAllMusicFetchEvent());

    ///!-----------Refresh Artist Data --------------///
    context.read<ArtistsDataBloc>().add(ArtistsDataFetchEvent());

    ///!-----------Refresh LOFIII Vibes Music --------------///
    context.read<LofiiiVibesMusicBloc>().add(LofIIIVibesMusicFetchEvent());
  }
}
