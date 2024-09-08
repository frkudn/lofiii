import 'package:lofiii/base/assets/app_fonts.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';

class YouTubeHomeCarouselCardWidget extends StatelessWidget {
  const YouTubeHomeCarouselCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            height: 0.46.sh,
            width: 0.9.sw,
            decoration: BoxDecoration(
                color: themeState.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color:
                          themeState.isDarkMode ? Colors.white38 : Colors.black26,
                      blurRadius: 1,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0.5),
                ]),
            child: Column(
              children: [
                ///-------------------- YOUTUBE THUMBNAIL -----------------------///
                Container(
                  height: 0.25.sh,
                  width: 0.9.sw,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: FadeInImage(
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
                Gap(5.sp),
          
                ///-------------------- YOUTUBE TITLE ------------------------------------///
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: const Text(
                      "CHAY NIGAY DI | RUN NOW | SON TUNG M-TP | OFFICIAL MUSIC VIDEO"),
                ),
          
                ///-------------------- YOUTUBE VIEWS & DATE TIME -----------------------///
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "120 M",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                      Gap(3.sp),
                      Text(
                        "|",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                      Gap(3.sp),
                      Text(
                        "August 15, 2024",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
                Gap(12.sp),
          
                ///-------------------- YOUTUBE CHANNEL AVATAR, NAME AND SUBSCRIBERS -----------------------///
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    children: [
                      ///------------ Channel Avatar --------------///
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage(AppSvgsImages.userDefaultProfileImage),
                      ),
          
                      Gap(8.sp),
          
                      ///-------------- Channel Name & Subscribers -----------///
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FURQAN UDDIN OFFICIAL",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.poppinBold),
                          ),
                          Gap(2.sp),
                          Text(
                            "10.75 M subscriber",
                            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                          ),
                        ],
                      ),
                      const Spacer(),
          
                      ///--------------- Heart Button --------------///
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                          ))
                    ],
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
