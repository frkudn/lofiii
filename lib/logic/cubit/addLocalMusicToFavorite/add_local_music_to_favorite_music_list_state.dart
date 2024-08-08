part of 'add_local_music_to_favorite_music_list_cubit.dart';

sealed class LocalMusicToFavoriteMusicListState extends Equatable {
  const LocalMusicToFavoriteMusicListState();

  @override
  List<Object> get props => [];
}

final class AddLocalMusicToFavoriteMusicListInitial
    extends LocalMusicToFavoriteMusicListState {}

final class CheckLocalMusicInFavoriteMusicListState
    extends LocalMusicToFavoriteMusicListState {
  CheckLocalMusicInFavoriteMusicListState({required this.available});

   bool available;
}

final class LocalMusicToFavoriteMusicListIsSuccessfullyAddedState
    extends LocalMusicToFavoriteMusicListState {}
    final class LocalMusicToFavoriteMusicListIsAlreadyExistsState
    extends LocalMusicToFavoriteMusicListState {}

final class LocalMusicToFavoriteMusicListIsSuccessfullyRemovedState
    extends LocalMusicToFavoriteMusicListState {}

final class LocalMusicToFavoriteMusicListFailureState
    extends LocalMusicToFavoriteMusicListState {
  LocalMusicToFavoriteMusicListFailureState({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
