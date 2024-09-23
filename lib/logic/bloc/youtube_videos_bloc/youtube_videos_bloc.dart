import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lofiii/data/models/youtube_video_model.dart';
import 'package:lofiii/data/repositories/youtube_repository.dart';
part 'youtube_videos_event.dart';
part 'youtube_videos_state.dart';

class YoutubeVideosBloc extends Bloc<YoutubeVideosEvent, YoutubeVideosState> {
  final YouTubeDataRepository ytRepository;
  YoutubeVideosBloc({required this.ytRepository})
      : super(YoutubeVideosLoadingState()) {
    on<FetchYoutubeVideosEvent>(_fetchYoutubeVideosEvent);
  }

  FutureOr<void> _fetchYoutubeVideosEvent(
      FetchYoutubeVideosEvent event, Emitter<YoutubeVideosState> emit) async {
    emit(YoutubeVideosLoadingState());
    try {
      List<YoutubeVideoModel> trendingMusicList =
          await ytRepository.fetchTrendingMusic();

      emit(YoutubeVideosSuccessState(trendingMusicList: trendingMusicList));
    } catch (e) {
      emit(YoutubeVideosFailureState(message: e.toString()));
    }
  }
}
