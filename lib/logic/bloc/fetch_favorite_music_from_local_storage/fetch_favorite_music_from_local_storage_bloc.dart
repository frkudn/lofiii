import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lofiii/data/models/local_music_model.dart';
import 'package:lofiii/base/services/app_permissions_service.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/base/services/hive/hive_services.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'fetch_favorite_music_from_local_storage_event.dart';
part 'fetch_favorite_music_from_local_storage_state.dart';

class FetchFavoriteMusicFromLocalStorageBloc extends Bloc<
    FetchFavoriteMusicFromLocalStorageEvent,
    FetchFavoriteMusicFromLocalStorageState> {
  final OnAudioQuery audioQuery = locator.get<OnAudioQuery>();
  FetchFavoriteMusicFromLocalStorageBloc()
      : super(FetchFavoriteMusicFromLocalStorageInitialState()) {
    on<FetchFavoriteMusicFromLocalStorageInitializationEvent>(
        _fetchFavoriteMusicFromLocalStorageInitializationEvent);
  }

  FutureOr<void> _fetchFavoriteMusicFromLocalStorageInitializationEvent(
    FetchFavoriteMusicFromLocalStorageEvent event,
    Emitter<FetchFavoriteMusicFromLocalStorageState> emit,
  ) async {
    try {
      if (await AppPermissionService.allPermission()) {
        emit(FetchFavoriteMusicFromLocalStorageLoadingState());

        List<String> localFavoriteMusicIds = MyHiveBoxes.libraryBox.get(
              MyHiveKeys.localFavoriteMusicListHiveKey,
            ) ??
            [];

        List<SongModel> musicList = await audioQuery.querySongs();

        List<SongModel> filteredMusicList = musicList.where((song) {
          return localFavoriteMusicIds
              .any((id) => song.id.toString().contains(id));
        }).toList();

        List<LocalMusicModel> favoriteMusicsWithArtwork = await Future.wait(
          filteredMusicList.map((song) async {
            Uint8List? artwork = await _getAudioArtwork(song.id);
            return LocalMusicModel(song: song, artwork: artwork);
          }).toList(),
        );

        emit(FetchFavoriteMusicFromLocalStorageSuccessState(
            favoriteMusicList: favoriteMusicsWithArtwork));
      } else {
        await AppPermissionService.allPermission();
      }
    } catch (e) {
      emit(FetchFavoriteMusicFromLocalStorageFailureState(
          errorMessage: e.toString()));
    }
  }

  Future<Uint8List?> _getAudioArtwork(int id) async {
    try {
      return await audioQuery.queryArtwork(id, ArtworkType.AUDIO,
          format: ArtworkFormat.PNG, quality: 100, size: 1000);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching artwork: $e");
      }
      return null;
    }
  }
}
