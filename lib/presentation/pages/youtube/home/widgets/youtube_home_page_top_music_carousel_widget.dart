import 'package:carousel_slider/carousel_slider.dart';
import 'package:lofiii/logic/cubit/youtube_carousel_indicators_index/youtube_carousel_indicators_index_cubit.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/you_tube_home_carousel_card_widget.dart';

class YoutubeHomePageTopMusicCarouselWidget extends StatelessWidget {
  const YoutubeHomePageTopMusicCarouselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return SliverToBoxAdapter(
          child: SizedBox(
            ///----------------- MAIN COLUMN --------------------///
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    YouTubeHomeCarouselCardWidget(),
                    YouTubeHomeCarouselCardWidget(),
                    YouTubeHomeCarouselCardWidget(),
                    YouTubeHomeCarouselCardWidget(),
                  ],
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
                        itemCount: 4,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.sp),
                          child: Container(
                            height:
                                ytIndicatorState.index == index ? 15.sp : 8.sp,
                            width:
                                ytIndicatorState.index == index ? 15.sp : 8.sp,
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
      },
    );
  }
}
