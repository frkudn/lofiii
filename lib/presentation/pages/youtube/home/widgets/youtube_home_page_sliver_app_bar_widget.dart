import 'package:lofiii/presentation/pages/youtube/exports.dart';

class YoutubeHomePageSliverAppBarWidget extends StatelessWidget {
  const YoutubeHomePageSliverAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          automaticallyImplyLeading: false,
          actions: _searchWidget(context, themeState),
        );
      },
    );
  }

  ///------------------------------------------------- Search Widget -----------------------------------------///
  List<Widget> _searchWidget(context, themeState) {
    return [
      Flexible(
        child: FadeInDown(
          child: GestureDetector(
            onTap: () {
              _searchWidgetOnTap(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
              decoration: BoxDecoration(
                color: themeState.isDarkMode ? Colors.black : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: themeState.isDarkMode
                          ? const Color.fromARGB(105, 255, 255, 255)
                          : const Color.fromARGB(42, 7, 3, 3),
                      blurRadius: 1,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0.5)
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ///----------------- YOUTUBE LOGO ------------------------///
                        const Icon(
                          FontAwesomeIcons.youtube,
                          color: Colors.red,
                        ),
                        Gap(4.sp),
                        Text(
                          "YouTube",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5),
                        ),
                      ],
                    ),

                    ///----------------------- SEARCH ICON ---------------------///
                    const Icon(Icons.search),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    ];
  }

  void _searchWidgetOnTap(context) {
    Navigator.pushNamed(context, AppRoutes.youtubeMusicSearchRoute);
  }

  ///------------------------------------------------- Search Widget OnTap -----------------------------------------///
}
