part of 'fetch_music_from_local_storage_bloc.dart';

@immutable
abstract class FetchMusicFromLocalStorageState extends Equatable{}

class FetchMusicFromLocalStorageInitial extends FetchMusicFromLocalStorageState {
  @override
  List<Object?> get props => [];
}
class FetchMusicFromLocalStorageLoadingState extends FetchMusicFromLocalStorageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class FetchMusicFromLocalStorageSuccessState extends FetchMusicFromLocalStorageState {

  final Future<List<SongModel>> musicsList;

  FetchMusicFromLocalStorageSuccessState({required this.musicsList});
  @override
  // TODO: implement props
  List<Object?> get props => [musicsList];
}

class FetchMusicFromLocalStorageFailureState extends FetchMusicFromLocalStorageState{

 final String failureMessage;

  FetchMusicFromLocalStorageFailureState({required this.failureMessage});
  @override
  // TODO: implement props
  List<Object?> get props => [failureMessage];
}
