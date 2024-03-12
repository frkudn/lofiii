import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'fetch_music_from_local_storage_event.dart';
part 'fetch_music_from_local_storage_state.dart';

class FetchMusicFromLocalStorageBloc extends Bloc<FetchMusicFromLocalStorageEvent, FetchMusicFromLocalStorageState> {
  FetchMusicFromLocalStorageBloc() : super(FetchMusicFromLocalStorageInitial()) {
    on<FetchMusicFromLocalStorageInitializationEvent>(_fetchMusicFromLocalStorageInitializationEvent);
  }

  FutureOr<void> _fetchMusicFromLocalStorageInitializationEvent(
      FetchMusicFromLocalStorageInitializationEvent event, Emitter<FetchMusicFromLocalStorageState> emit) async {
    try {
      // List to hold music files
      List<FileSystemEntity> musicsList = [];

      // Check if storage permission is granted
      if (await Permission.storage.isGranted) {
        // Get the directory where music files are stored
        final Directory musicDir = Directory("/storage/emulated/0/Music");

        // Check if directory exists
        if (musicDir.existsSync()) {
          // Get list of files in the directory
          final List<FileSystemEntity> _files =
          musicDir.listSync(recursive: true, followLinks: false);
          for (FileSystemEntity entity in _files) {
            // Check if file is a music file (mp3 or m4a)
            String path = entity.path;
            if (path.endsWith('.mp3') || path.endsWith(".m4a")) {
              // Add music file to the list
              musicsList.add(entity);
              // Emit success state with updated music list
              emit(FetchMusicFromLocalStorageSuccessState(musicsList: musicsList));
            }
          }
        }
      } else {
        // If storage permission is not granted, request permissions based on Android version
        final DeviceInfoPlugin info = DeviceInfoPlugin();
        final AndroidDeviceInfo androidInfo = await info.androidInfo;
        final int androidVersion = int.parse(androidInfo.version.release);
        if (androidVersion >= 13) {
          // Request notification, storage, and manage external storage permissions
          await Permission.notification.request();
          await Permission.storage.request();
          await Permission.manageExternalStorage.request();
        } else {
          // Request notification and storage permissions
          await Permission.notification.request();
          await Permission.storage.request();
        }
      }
    } catch (e) {
      // Handle any errors that occur during the process
      emit(FetchMusicFromLocalStorageFailureState(failureMessage: e.toString()));
    }
  }
}
