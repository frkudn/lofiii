part of 'youtube_carousel_indicators_index_cubit.dart';

class YoutubeCarouselIndicatorsIndexState extends Equatable {
  const YoutubeCarouselIndicatorsIndexState({required this.index});

  final int index;

  YoutubeCarouselIndicatorsIndexState copyWith({required int index}) {
    return YoutubeCarouselIndicatorsIndexState(index: index);
  }

  @override
  List<Object> get props => [index];
}
