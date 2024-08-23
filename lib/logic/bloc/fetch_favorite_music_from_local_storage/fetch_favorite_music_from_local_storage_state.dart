part of 'fetch_favorite_music_from_local_storage_bloc.dart';

sealed class FetchFavoriteMusicFromLocalStorageState extends Equatable {
  const FetchFavoriteMusicFromLocalStorageState();

  @override
  List<Object> get props => [];
}

final class FetchFavoriteMusicFromLocalStorageInitialState
    extends FetchFavoriteMusicFromLocalStorageState {}

final class FetchFavoriteMusicFromLocalStorageLoadingState
    extends FetchFavoriteMusicFromLocalStorageState {}

final class FetchFavoriteMusicFromLocalStorageSuccessState
    extends FetchFavoriteMusicFromLocalStorageState {
  const FetchFavoriteMusicFromLocalStorageSuccessState(
      {required this.favoriteMusicList});
  final List<LocalMusicModel> favoriteMusicList;

  @override
  List<Object> get props => [favoriteMusicList];
}

final class FetchFavoriteMusicFromLocalStorageFailureState
    extends FetchFavoriteMusicFromLocalStorageState {
  final String errorMessage;

  const FetchFavoriteMusicFromLocalStorageFailureState(
      {required this.errorMessage});
}
