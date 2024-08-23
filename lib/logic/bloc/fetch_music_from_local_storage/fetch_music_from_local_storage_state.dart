part of 'fetch_music_from_local_storage_bloc.dart';

@immutable
abstract class FetchMusicFromLocalStorageState extends Equatable {}

class FetchMusicFromLocalStorageInitial
    extends FetchMusicFromLocalStorageState {
  @override
  List<Object?> get props => [];
}

class FetchMusicFromLocalStorageLoadingState
    extends FetchMusicFromLocalStorageState {
  @override
  List<Object?> get props => [];
}

class FetchMusicFromLocalStorageSuccessState
    extends FetchMusicFromLocalStorageState {
  final List<LocalMusicModel> musicsList;

  FetchMusicFromLocalStorageSuccessState({required this.musicsList});
  @override
  List<Object?> get props => [musicsList];
}

class FetchMusicFromLocalStorageFailureState
    extends FetchMusicFromLocalStorageState {
  final String failureMessage;

  FetchMusicFromLocalStorageFailureState({required this.failureMessage});
  @override
  List<Object?> get props => [failureMessage];
}
