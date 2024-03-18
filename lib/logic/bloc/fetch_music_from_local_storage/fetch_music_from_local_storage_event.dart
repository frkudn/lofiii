part of 'fetch_music_from_local_storage_bloc.dart';

@immutable
abstract class FetchMusicFromLocalStorageEvent extends Equatable {}

class FetchMusicFromLocalStorageInitializationEvent extends FetchMusicFromLocalStorageEvent{
  @override
  List<Object?> get props => [];

}
