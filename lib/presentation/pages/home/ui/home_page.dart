import 'package:lofiii/presentation/pages/downloads/exports.dart';

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
          child: BlocBuilder<LofiiiMusicBloc, LofiiiMusicState>(
            builder: (context, state) {
              ///--------------------- STATE IS SUCCESS  -----------------------///
              if (state is LofiiiMusicSuccessState) {
                return CustomScrollView(
                  key: const PageStorageKey("homePageStorageKey"),
                  slivers: [
                    ///?-------------------------App Bar ----------------------///
                    HomePageSliverAppBar(
                      lofiiiMusicSuccessState: state,
                    ),

                    ///?-------AppBar Bottom Padding
                    SliverPadding(padding: EdgeInsets.only(bottom: 20.h)),

                    ///?----------------------Special Section----------------------///
                    ///!-   --------------       Special Heading
                    HeadingWithViewMoreButton(
                        heading: "LOFIII Special",
                        viewMoreOnTap: () {
                          _viewMoreButtonOnTap(
                              state.specialMusic, "LOFIII Special", context);
                        }),

                    ///! ---------------       Special  Music List   ---------------///
                    MusicCardsListWidget(
                      list: state.specialMusic,
                      pageStorageKey: "specialStorageKey",
                    ),

                    ///?----------------------Lo-fi Popular Section----------------------///
                    ///! --------------------------      Popular    Heading
                    HeadingWithViewMoreButton(
                        heading: "LOFIII Popular",
                        viewMoreOnTap: () {
                          _viewMoreButtonOnTap(
                              state.popularMusic, "LOFIII Popular", context);
                        }),

                    ///! ----------------------------       Popular  Music List      --------------//////
                    MusicCardsListWidget(
                      list: state.popularMusic,
                      pageStorageKey: "popularStorageKey",
                    ),

                    ///?------------------           Artists Section      ------------------///
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
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),

                    ///!List
                    ArtistsCardsListWidget(
                      artistList: state.artistsMusic,
                    ),

                    ///?----------------------       TopPicks Section        ----------------------///
                    ///! --------------------------      TopPicks    Heading
                    HeadingWithViewMoreButton(
                        heading: "LOFIII TopPicks",
                        viewMoreOnTap: () {
                          _viewMoreButtonOnTap(
                              state.topPicksMusic, "LOFIII TopPicks", context);
                        }),

                    ///! ----------------------------       TopPicks  Music List      --------------//////
                    MusicCardsListWidget(
                      list: state.topPicksMusic,
                      pageStorageKey: "topPicksStorageKey",
                    ),

                    ///-------------------------------------------------------------------------///
                    ///?----------------------Lo-fi Vibes Section----------------------///
                    ///! --------------------------      Vibes    Heading
                    HeadingWithViewMoreButton(
                        heading: "LOFIII Vibes",
                        viewMoreOnTap: () {
                          _viewMoreButtonOnTap(
                              state.vibesMusic, "LOFIII Vibes", context);
                        }),

                    ///! ----------------------------       Vibes  Music List      --------------//////
                    MusicCardsListWidget(
                      list: state.vibesMusic,
                      pageStorageKey: "vibesStorageKey",
                    ),

                    ///!-------------------------------   Extra Space in Bottom  ------------------------------------------///

                    SliverToBoxAdapter(
                      child: Gap(
                        0.15.sh,
                      ),
                    ),
                  ],
                );

                ///--------------------- STATE IS Loading  -----------------------///
              } else if (state is LofiiiMusicLoadingState) {
                return const SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(120),
                      ListViewShimmerBoxWidget(),
                      Gap(20),
                      ListViewShimmerBoxWidget(),
                      Gap(20),
                      HorizontalCircularBoxListViewShimmerBoxWidget(),
                      Gap(20),
                      ListViewShimmerBoxWidget(),
                      Gap(20),
                      ListViewShimmerBoxWidget(),
                      Gap(100),
                    ],
                  ),
                );
              }

              ///--------------------- STATE IS Failure  -----------------------///

              else if (state is LofiiiMusicFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.errorMessage.contains("SocketException")) ...[
                        const NoInternetLottieAnimation(),
                        Center(
                          child: TextAnimator(
                            atRestEffect: WidgetRestingEffects.wave(),
                            "Please check your internet connection",
                          ),
                        ),
                      ],
                      if (!state.errorMessage.contains("SocketException"))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(state.errorMessage),
                          ),
                        ),
                      Spin(
                        child: IconButton(
                          tooltip: "Refresh",
                          onPressed: _onRefreshMethod,
                          icon: const Icon(FontAwesomeIcons.arrowsRotate),
                        ),
                      )
                    ],
                  ),
                );
              }

              ///--------------------- Else  -----------------------///

              else {
                return const Center(
                  child: Text("Something went wrong, refresh the page"),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  ///?---------------------------- M E T H O D S --------------------///
  ///----On Refreshing
  Future<void> _onRefreshMethod() async {
    context.read<LofiiiMusicBloc>().add(LOFIIIMusicFetchEvent());
  }

  ///--------- OnTap of View More
  void _viewMoreButtonOnTap(
      List<MusicModel> musicList, String heading, BuildContext context) {
    Map<String, dynamic> arguments = {
      "topHeading": heading,
      "musicList": musicList,
    };

    Navigator.pushNamed(context, AppRoutes.viewMoreOnlineMusicRoute,
        arguments: arguments);
  }
}
