import 'package:lofiii/data/models/youtube_video_model.dart';
import 'package:lofiii/presentation/pages/youtube/exports.dart';

class YoutubeVideoKeywordsListWidget extends StatelessWidget {
  const YoutubeVideoKeywordsListWidget({
    super.key,
    required this.video,
  });

  final YoutubeVideoModel video;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: video.keywords.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            video.keywords[index],
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 6.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
