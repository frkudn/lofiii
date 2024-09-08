import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'youtube_carousel_indicators_index_state.dart';

class YoutubeCarouselIndicatorsIndexCubit
    extends Cubit<YoutubeCarouselIndicatorsIndexState> {
  YoutubeCarouselIndicatorsIndexCubit()
      : super(const YoutubeCarouselIndicatorsIndexState(index: 0));

  updateIndicatorIndex({required int index}) {
    emit(state.copyWith(index: index));
  }
}
