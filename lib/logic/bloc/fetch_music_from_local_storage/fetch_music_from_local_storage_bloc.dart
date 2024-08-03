import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lofiii/data/services/app_permissions_service.dart';
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
      //! Check if storage permission is granted
      if (await AppPermissionService.storagePermission()) {
        emit(FetchMusicFromLocalStorageLoadingState());

        Future<List<SongModel>> musicList = audioQuery.querySongs();

        //! Emit success state with updated music list
        emit(FetchMusicFromLocalStorageSuccessState(musicsList:musicList));
      } else {
        await AppPermissionService.storagePermission();
      }
    } catch (e) {
      //! Handle any errors that occur during the process
      emit(
          FetchMusicFromLocalStorageFailureState(failureMessage: e.toString()));
    }
  }
}
