part of 'fetch_favorite_music_from_local_storage_bloc.dart';

sealed class FetchFavoriteMusicFromLocalStorageEvent extends Equatable {
  const FetchFavoriteMusicFromLocalStorageEvent();

  @override
  List<Object> get props => [];
}

class FetchFavoriteMusicFromLocalStorageInitializationEvent extends FetchFavoriteMusicFromLocalStorageEvent{}
