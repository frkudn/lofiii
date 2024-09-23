import 'package:lofiii/base/assets/app_fonts.dart';
import 'package:lofiii/data/models/youtube_video_model.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/youtube_carousel_card_views_and_date_time_widget.dart';
import 'package:lofiii/presentation/pages/youtube/home/widgets/youtube_video_keywords_list_widget.dart';

class YouTubeHomeCarouselCardWidget extends StatelessWidget {
  const YouTubeHomeCarouselCardWidget({super.key, required this.video});

  final YoutubeVideoModel video;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            height: 0.48.sh,
            width: 0.9.sw,
            decoration: BoxDecoration(
                color: themeState.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: themeState.isDarkMode
                          ? Colors.white38
                          : Colors.black26,
                      blurRadius: 1,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0.5),
                ]),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ///-------------------- YOUTUBE THUMBNAIL -----------------------///
                  Container(
                    height: 0.25.sh,
                    width: 0.9.sw,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            video.thumbnails.standardResUrl),
                        placeholder: const AssetImage(
                          AppSvgsImages.userDefaultProfileImage,
                        ),
                      ),
                    ),
                  ),
                  Gap(5.sp),

                  ///-------------------- YOUTUBE TITLE ------------------------------------///
                  Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Text(
                      video.title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  ///-------------------- YOUTUBE Keywords ------------------------------------///
                  if (video.keywords.first.isNotEmpty)
                    YoutubeVideoKeywordsListWidget(video: video),
                  const Gap(5),

                  ///-------------------- YOUTUBE VIEWS & DATE TIME -----------------------///
                  YoutubeCarouselCardViewsAndDateTimeWidget(video: video),
                  Gap(12.sp),

                  ///-------------------- YOUTUBE CHANNEL AVATAR, NAME AND SUBSCRIBERS -----------------------///
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Row(
                      children: [
                        ///------------ Channel Avatar --------------///
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(video.channel.logoUrl),
                        ),

                        Gap(8.sp),

                        ///-------------- Channel Name & Subscribers -----------///
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.author,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.poppinBold),
                              ),
                            ],
                          ),
                        ),

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
          ),
        );
      },
    );
  }
}
