import 'package:lofiii/presentation/pages/youtube/exports.dart';

class YouTubeHomeWhatsHotTodayWidget extends StatelessWidget {
  const YouTubeHomeWhatsHotTodayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 15.sp),
            child: SizedBox(
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///------------------- Heading -----------------///
                      FadeInLeft(
                        child: Text(
                          "What's Hot Today",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                      ),
                      Gap(8.sp),

                      ///--------------- Music Cards List ------------------------///
                      FadeInUp(
                        child: SizedBox(
                          height: 0.15.sh,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>

                                ///--------------- Music Card ------------------------///
                                Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.sp),
                              child: Container(
                                width: 0.5.sw,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                        color: themeState.isDarkMode
                                            ? Colors.white38
                                            : Colors.black26,
                                        blurRadius: 1,
                                        blurStyle: BlurStyle.outer,
                                        spreadRadius: 0.5),
                                  ],
                                ),
                                child: ClipRRect(
                                   borderRadius: BorderRadius.circular(10),
                                  child: const FadeInImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      AppSvgsImages.userDefaultProfileImage,
                                    ),
                                    placeholder: AssetImage(
                                      AppSvgsImages.userDefaultProfileImage,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
