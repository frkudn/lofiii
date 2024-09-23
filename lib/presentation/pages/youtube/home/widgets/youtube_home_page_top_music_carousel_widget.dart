import 'package:carousel_slider/carousel_slider.dart';
import 'package:lofiii/logic/bloc/youtube_videos_bloc/youtube_videos_bloc.dart';
import 'package:lofiii/logic/cubit/youtube_carousel_indicators_index/youtube_carousel_indicators_index_cubit.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/youtube_home_carousel_card_widget.dart';

class YoutubeHomePageTopMusicCarouselWidget extends StatelessWidget {
  const YoutubeHomePageTopMusicCarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YoutubeVideosBloc, YoutubeVideosState>(
      builder: (context, ytVideoState) {
        return BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, themeState) {
          ///----------------- IF Success State ------------------------///
          if (ytVideoState is YoutubeVideosSuccessState) {
            return SliverToBoxAdapter(
              child: SizedBox(
                ///----------------- MAIN COLUMN --------------------///
                child: Column(
                  children: [
                    CarouselSlider(
                      items: ytVideoState.trendingMusicList
                          .map(
                            (e) => YouTubeHomeCarouselCardWidget(
                              video: e,
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          context
                              .read<YoutubeCarouselIndicatorsIndexCubit>()
                              .updateIndicatorIndex(index: index);
                        },
                        height: 0.5.sh,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.85,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                        pauseAutoPlayOnTouch: true,
                      ),
                    ),

                    Gap(0.03.sh),

                    ///----------------- CAROUSEL DOTS INDICATORS -----------------------///
                    Container(
                      height: 20,
                      width: 1.sw,
                      // color: Colors.red,
                      alignment: Alignment.center,
                      child: BlocBuilder<YoutubeCarouselIndicatorsIndexCubit,
                          YoutubeCarouselIndicatorsIndexState>(
                        builder: (context, ytIndicatorState) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: ytVideoState.trendingMusicList.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.sp),
                              child: Container(
                                height: ytIndicatorState.index == index
                                    ? 12.sp
                                    : 4.sp,
                                width: ytIndicatorState.index == index
                                    ? 12.sp
                                    : 4.sp,
                                decoration: BoxDecoration(
                                  color: ytIndicatorState.index == index
                                      ? Color(themeState.accentColor)
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          ///----------------------- If Loading State -------------------------////
          else if (ytVideoState is YoutubeVideosLoadingState) {
            return SliverToBoxAdapter(
              child: Column(
                children: [
                  ListViewShimmerBoxWidget(
                    showHeader: false,
                    boxHeight: 0.42.sh,
                    boxWidth: 1.sw,
                    itemHeight: 0.44.sh,
                    itemWidth: 0.85.sw,
                    scrollDirection: Axis.horizontal,
                  ),
                  const Gap(3),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 4,
                      ),
                      Gap(2),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 4,
                      ),
                      Gap(2),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 4,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          ///--------------------- If Failed State ------------------------------///
          else if (ytVideoState is YoutubeVideosFailureState) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: 0.5.sh,
                width: 1.sw,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(ytVideoState.message),
                  ),
                ),
              ),
            );
          } else {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
        });
      },
    );
  }
}
