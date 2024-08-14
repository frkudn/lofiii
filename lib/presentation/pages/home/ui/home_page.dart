import '../exports.dart';

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
                  return state is LofiiiSpecialMusicSuccessState
                      ? HeadingWithViewMoreButton(
                          heading: "LOFIII Special",
                          viewMoreOnTap: () {

                             _viewMoreButtonOnTap(
                                state, "LOFIII Special", context);

                         
                          })
                      : const SliverToBoxAdapter();
                },
              ),

              ///! ---------------       Special  Music List   ---------------///
              BlocBuilder<LofiiiSpecialMusicBloc, LofiiiSpecialMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiSpecialMusicSuccessState) {
                    ///----- Music List

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
                            child:
                                Text("Something went wrong, refresh the page"),
                          ),
                        ),
                      );
                    }

                    //!-----    LofiiiSpecialMusicLoadingState
                  } else if (state is LofiiiSpecialMusicLoadingState) {
                    return SliverToBoxAdapter(
                      child: ListViewShimmerBoxWidget(),
                    );
                  }
                  //? ---- Music State is Failure State
                  else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const NoInternetLottieAnimation(),
                          const Text("Refresh Now"),
                          IconButton(
                              onPressed: _onRefreshMethod,
                              icon: const Icon(FontAwesomeIcons.arrowsRotate))
                        ],
                      ),
                    );
                  }
                },
              ),

              ///?----------------------Lo-fi Popular Section----------------------///
              ///! --------------------------      Popular    Heading
              BlocBuilder<LofiiiPopularMusicBloc, LofiiiPopularMusicState>(
                builder: (context, state) {
                  return state is LofiiiPopularMusicSuccessState
                      ? HeadingWithViewMoreButton(
                          heading: "LOFIII Popular",
                          viewMoreOnTap: () {
                            _viewMoreButtonOnTap(
                                state, "LOFIII Popular", context);
                          })
                      : const SliverToBoxAdapter();
                },
              ),

              ///! ----------------------------       Popular  Music List      --------------//////
              BlocBuilder<LofiiiPopularMusicBloc, LofiiiPopularMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiPopularMusicSuccessState) {
                    ///---------------- Music List

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
                      child: ListViewShimmerBoxWidget(),
                    );
                  }
                  //? ----   Music State is Failure State
                  else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const NoInternetLottieAnimation(),
                          const Text("Refresh Now"),
                          IconButton(
                              onPressed: _onRefreshMethod,
                              icon: const Icon(FontAwesomeIcons.arrowsRotate))
                        ],
                      ),
                    );
                  }
                },
              ),

              ///?------------------           Artists Section      ------------------///
              ///!Heading
              BlocBuilder<ArtistsDataBloc, ArtistsDataState>(
                builder: (context, state) {
                  return state is ArtistsDataSuccessState
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Top Artists",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  letterSpacing: 1,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        )
                      : const SliverToBoxAdapter();
                },
              ),

              BlocBuilder<ArtistsDataBloc, ArtistsDataState>(
                builder: (context, state) {
                  ///!------------     If Success
                  if (state is ArtistsDataSuccessState) {
                    ///----- Music List -------///

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
                    return const SliverToBoxAdapter(
                      child: HorizontalCircularBoxListViewShimmerBoxWidget(),
                    );
                  }

                  ///!--------   If No Internet Or Server Error
                  else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const NoInternetLottieAnimation(),
                          const Text("Refresh Now"),
                          IconButton(
                              onPressed: _onRefreshMethod,
                              icon: const Icon(FontAwesomeIcons.arrowsRotate))
                        ],
                      ),
                    );
                  }
                },
              ),

              ///?----------------------       TopPicks Section        ----------------------///
              ///! --------------------------      TopPicks    Heading
              BlocBuilder<LofiiiTopPicksMusicBloc, LofiiiTopPicksMusicState>(
                builder: (context, state) {
                  return state is LofiiiTopPicksMusicSuccessState
                      ? HeadingWithViewMoreButton(
                          heading: "LOFIII TopPicks",
                          viewMoreOnTap: () {
                              _viewMoreButtonOnTap(
                                state, "LOFIII TopPicks", context);
                            
                          
                          })
                      : const SliverToBoxAdapter();
                },
              ),

              ///! ----------------------------       TopPicks  Music List      --------------//////
              BlocBuilder<LofiiiTopPicksMusicBloc, LofiiiTopPicksMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiTopPicksMusicSuccessState) {
                    ///-------------- Music List --------------///

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
                      child: ListViewShimmerBoxWidget(),
                    );
                  }
                  //? ----       Music State is Failure State
                  else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const NoInternetLottieAnimation(),
                          const Text("Refresh Now"),
                          IconButton(
                              onPressed: _onRefreshMethod,
                              icon: const Icon(FontAwesomeIcons.arrowsRotate))
                        ],
                      ),
                    );
                  }
                },
              ),

              ///-------------------------------------------------------------------------///
              ///?----------------------Lo-fi Vibes Section----------------------///
              ///! --------------------------      Vibes    Heading
              BlocBuilder<LofiiiVibesMusicBloc, LofiiiVibesMusicState>(
                builder: (context, state) {
                  return state is LofiiiVibesMusicSuccessState
                      ? HeadingWithViewMoreButton(
                          heading: "LOFIII Vibes",
                          viewMoreOnTap: () {
                             _viewMoreButtonOnTap(
                                state, "LOFIII Vibes", context);
                        
                          })
                      : const SliverToBoxAdapter();
                },
              ),

              ///! ----------------------------       Vibes  Music List      --------------//////
              BlocBuilder<LofiiiVibesMusicBloc, LofiiiVibesMusicState>(
                builder: (context, state) {
                  //?----Fetching music is success
                  if (state is LofiiiVibesMusicSuccessState) {
                    ///------------- Music List -----///

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
                      child: ListViewShimmerBoxWidget(),
                    );
                  }
                  //? ----   Music State is Failure State
                  else {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const NoInternetLottieAnimation(),
                          const Text("Refresh Now"),
                          IconButton(
                              onPressed: _onRefreshMethod,
                              icon: const Icon(FontAwesomeIcons.arrowsRotate))
                        ],
                      ),
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


  void _viewMoreButtonOnTap( state,
      String heading, BuildContext context) {
    Map<String, dynamic> arguments = {
      "topHeading": heading,
      "musicList": state.musicList,
    };

    Navigator.pushNamed(context, AppRoutes.viewMoreOnlineMusicRoute,
        arguments: arguments);
  }
}
