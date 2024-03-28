part of 'youtube_music_cubit.dart';

@immutable
sealed class YoutubeMusicState extends Equatable {}

final class YoutubeMusicInitialState extends YoutubeMusicState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class YoutubeMusicLoadingState extends YoutubeMusicState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class YoutubeMusicSuccessState extends YoutubeMusicState {
  YoutubeMusicSuccessState({
    required this.musicList,
    required this.favoriteFuturePlayLists,
  });
  final Future<List<Video>> musicList;
  final List<Future<List<Video>>> favoriteFuturePlayLists;

  @override
  // TODO: implement props
  List<Object?> get props => [musicList, favoriteFuturePlayLists];
}

final class YoutubeMusicSearchState extends YoutubeMusicState {
  YoutubeMusicSearchState(
      {required this.searchList,
      required this.searchSuggestions,
      required this.showSuggestion});
  final Future<List<Video>> searchList;
  final Future<List<String>> searchSuggestions;
  bool showSuggestion;

  YoutubeMusicSearchState copyWith({showSuggestion, searchList, searchSuggestions}) {
    return YoutubeMusicSearchState(
        showSuggestion: showSuggestion ?? this.showSuggestion,
        searchList: searchList??this.searchList,
        searchSuggestions: searchSuggestions??this.searchSuggestions);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [searchList, searchSuggestions, showSuggestion];
}

final class YoutubeMusicErrorState extends YoutubeMusicState {
  YoutubeMusicErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];
}
