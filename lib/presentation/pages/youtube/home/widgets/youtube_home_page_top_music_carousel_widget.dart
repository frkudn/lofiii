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
                const YouTubeHomeCarouselCardWidget(),

                Gap(0.03.sh),

                ///----------------- CAROUSEL DOTS INDICATORS -----------------------///
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10.sp,
                        color: const Color.fromARGB(145, 158, 158, 158),
                      ),
                      Icon(
                        Icons.circle,
                        size: 10.sp,
                        color: const Color.fromARGB(145, 158, 158, 158),
                      ),
                      Icon(
                        Icons.circle,
                        size: 10.sp,
                      ),
                      Icon(
                        Icons.circle,
                        size: 10.sp,
                        color: const Color.fromARGB(145, 158, 158, 158),
                      ),
                      Icon(
                        Icons.circle,
                        size: 10.sp,
                        color: const Color.fromARGB(145, 158, 158, 158),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
