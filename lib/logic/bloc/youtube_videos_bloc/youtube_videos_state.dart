part of 'youtube_videos_bloc.dart';

sealed class YoutubeVideosState extends Equatable {
  const YoutubeVideosState();

  List<Object> get props => [];
}

final class YoutubeVideosLoadingState extends YoutubeVideosState {}

final class YoutubeVideosSuccessState extends YoutubeVideosState {
  const YoutubeVideosSuccessState({required this.trendingMusicList});
  final List<YoutubeVideoModel> trendingMusicList;

  List<Object> get props => [trendingMusicList];
}

final class YoutubeVideosFailureState extends YoutubeVideosState {
  const YoutubeVideosFailureState({required this.message});

  final String message;
}
