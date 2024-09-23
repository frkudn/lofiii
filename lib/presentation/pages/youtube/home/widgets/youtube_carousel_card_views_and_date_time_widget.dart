import 'package:lofiii/data/models/youtube_video_model.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class YoutubeCarouselCardViewsAndDateTimeWidget extends StatelessWidget {
  const YoutubeCarouselCardViewsAndDateTimeWidget({
    super.key,
    required this.video,
  });

  final YoutubeVideoModel video;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.sp,
      ),
      child: Row(
        children: [
          Text(
            video.views ?? "unknown",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
          Gap(3.sp),
          Text(
            "|",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
          Gap(3.sp),
          Text(
            timeago.format(video.uploadDate!),
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
