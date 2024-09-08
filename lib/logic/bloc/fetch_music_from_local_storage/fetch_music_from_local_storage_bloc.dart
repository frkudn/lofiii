import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lofiii/data/models/local_music_model.dart';
import 'package:lofiii/base/services/app_permissions_service.dart';
import 'package:lofiii/exports.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'fetch_music_from_local_storage_event.dart';
part 'fetch_music_from_local_storage_state.dart';

class FetchMusicFromLocalStorageBloc extends Bloc<
    FetchMusicFromLocalStorageEvent, FetchMusicFromLocalStorageState> {
  final OnAudioQuery audioQuery = locator.get<OnAudioQuery>();

  FetchMusicFromLocalStorageBloc()
      : super(FetchMusicFromLocalStorageInitial()) {
    on<FetchMusicFromLocalStorageInitializationEvent>(
        _fetchMusicFromLocalStorageInitializationEvent);
  }

  FutureOr<void> _fetchMusicFromLocalStorageInitializationEvent(
    FetchMusicFromLocalStorageInitializationEvent event,
    Emitter<FetchMusicFromLocalStorageState> emit,
  ) async {
    try {
      if (await AppPermissionService.allPermission()) {
        emit(FetchMusicFromLocalStorageLoadingState());

        List<SongModel> musicList = await audioQuery.querySongs();

        List<SongModel> onlyMusic = musicList
            .where(
              (music) =>
                  music.isMusic == true &&
                  music.isAudioBook == false &&
                  music.isNotification == false &&
                  music.isPodcast == false &&
                  music.isAlarm == false &&
                  music.isRingtone == false &&
                  !music.displayName.contains("PTT-"),
            )
            .toList();

        // List<LocalMusicModel>
        List<LocalMusicModel> localMusicList = await Future.wait(
          onlyMusic.map(
            (song) async {
              Uint8List? artwork = await _getAudioArtwork(song.id);
              return LocalMusicModel(song: song, artwork: artwork);
            },
          ).toList(),
        );

        emit(FetchMusicFromLocalStorageSuccessState(
          musicsList: localMusicList,
        ));
      } else {
        await AppPermissionService.allPermission();
      }
    } catch (e) {
      emit(FetchMusicFromLocalStorageFailureState(
        failureMessage: e.toString(),
      ));
    }
  }

// Helper method to fetch audio artwork
  Future<Uint8List?> _getAudioArtwork(int id) async {
    try {
      // Query artwork from device storage
      return await audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.PNG,
        quality: 100,
        size: 500,
      );
    } catch (e) {
      // Print error message in debug mode
      if (kDebugMode) {
        print("Error fetching artwork: $e");
      }
      return null;
    }
  }

  // ... other methods remain the same
}
