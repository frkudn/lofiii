import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lofiii/data/services/app_permissions_service.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/resources/hive/hive_resources.dart';
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

        on<FetchFavoriteMusicFromLocalStorageInitializationEvent>(_fetchFavoriteMusicFromLocalStorageInitializationEvent);
  }

  FutureOr<void> _fetchMusicFromLocalStorageInitializationEvent(
      FetchMusicFromLocalStorageInitializationEvent event,
      Emitter<FetchMusicFromLocalStorageState> emit) async {
    try {
      //! Check if storage permission is granted
      if (await AppPermissionService.storagePermission()) {
        emit(FetchMusicFromLocalStorageLoadingState());

        List<SongModel> musicList = await audioQuery.querySongs();

        //! Emit success state with updated music list
        emit(FetchMusicFromLocalStorageSuccessState(musicsList: musicList));
      } else {
        await AppPermissionService.storagePermission();
      }
    } catch (e) {
      //! Handle any errors that occur during the process
      emit(
          FetchMusicFromLocalStorageFailureState(failureMessage: e.toString()));
    }
  }

  FutureOr<void> _fetchFavoriteMusicFromLocalStorageInitializationEvent(
    FetchFavoriteMusicFromLocalStorageInitializationEvent event,
    Emitter emit,
  ) async {
    try {
      // Check if storage permission is granted
      if (await AppPermissionService.storagePermission()) {
        emit(FetchMusicFromLocalStorageLoadingState());

        // Get local favorite music titles from Hive
        List<String> localFavoriteMusicTitles = MyHiveBoxes.libraryBox.get(
              MyHiveKeys.localFavoriteMusicListHiveKey,
            ) ??
            [];

        // Query songs from device storage
        List<SongModel> musicList = await audioQuery.querySongs();

        // Filter music list where title contains any of the local favorite music titles
        List<SongModel> filteredMusicList = musicList.where((song) {
          return localFavoriteMusicTitles
              .any((title) => song.title.contains(title));
        }).toList();

        // Emit success state with updated music list
        emit(FetchFavoriteMusicFromLocalStorageSuccessState(
            musicsList: filteredMusicList));
      } else {
        // Request storage permission if not granted
        await AppPermissionService.storagePermission();
      }
    } catch (e) {
      // Handle any errors that occur during the process
      emit(
        FetchMusicFromLocalStorageFailureState(failureMessage: e.toString()),
      );
    }
  }
}
