import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lofiii/data/services/storage_permission_service.dart';

import 'package:permission_handler/permission_handler.dart';

part 'download_music_event.dart';
part 'download_music_state.dart';

class DownloadMusicBloc extends Bloc<DownloadMusicEvent, DownloadMusicState> {
  // final MediaDownload mediaDownloader;
  final Dio dio;

  DownloadMusicBloc({required this.dio}) : super(DownloadMusicInitialState()) {
    on<DownloadNowEvent>(_downloadNowEvent);
    on<MusicIsSuccessfullyDownloadedEvent>(_musicIsSuccessfullyDownloadedEvent);
  }

  Future<void> _downloadNowEvent(
      DownloadNowEvent event, Emitter<DownloadMusicState> emit) async {
 // Check if storage write permission is granted
    if (await StoragePermissionService.storagePermission()) {
      try {
        emit(DownloadMusicLoadingState(fileName: event.fileName));


        final musicDir = Directory("/storage/emulated/0/Music/").path;

        await dio.download(
          event.url,
          '$musicDir${event.fileName.trim()}.m4a',
          onReceiveProgress: (received, total) {
            log('percentage: ${(received / total * 100).toStringAsFixed(0)}%');
            emit(DownloadMusicProgressState(progress: (received / total * 100)));
          },
        );

        add(MusicIsSuccessfullyDownloadedEvent(fileName: event.fileName));

        await Future.delayed(const Duration(seconds: 10));
        emit(DownloadMusicInitialState());
      } catch (e) {
        emit(DownloadMusicFailureState(errorMessage: e.toString()));
        log(e.toString());
        await Future.delayed(const Duration(seconds: 10));
        emit(DownloadMusicInitialState());
      }
    } else {
      await Permission.storage.request();
    }
  }

  Future<void> _musicIsSuccessfullyDownloadedEvent(
      MusicIsSuccessfullyDownloadedEvent event,
      Emitter<DownloadMusicState> emit) async {
    emit(DownloadMusicSuccessState(fileName: event.fileName));
  }
}
