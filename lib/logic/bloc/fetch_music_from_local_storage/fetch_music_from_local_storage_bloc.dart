import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lofiii/data/models/song_with_artwork_model.dart';
import 'package:lofiii/base/services/app_permissions_service.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:meta/meta.dart';
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
      Emitter<FetchMusicFromLocalStorageState> emit) async {
    try {
      if (await AppPermissionService.storagePermission()) {
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

        List<SongWithArtwork> musicWithArtwork = await Future.wait(
          onlyMusic.map((song) async {
            Uint8List? artwork = await _getAudioArtwork(song.id);
            return SongWithArtwork(song: song, artwork: artwork);
          }).toList(),
        );

        emit(FetchMusicFromLocalStorageSuccessState(
            musicsList: musicWithArtwork));
      } else {
        await AppPermissionService.storagePermission();
      }
    } catch (e) {
      emit(
          FetchMusicFromLocalStorageFailureState(failureMessage: e.toString()));
    }
  }

  Future<Uint8List?> _getAudioArtwork(int id) async {
    try {
      return await audioQuery.queryArtwork(id, ArtworkType.AUDIO,
          format: ArtworkFormat.PNG, quality: 100, size: 200);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching artwork: $e");
      }
      return null;
    }
  }

  // ... other methods remain the same
}
