import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:path_provider/path_provider.dart';
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
    PermissionStatus storagePermissionStatus = await Permission.storage.status;
    if (storagePermissionStatus.isGranted) {
      try {
        emit(DownloadMusicLoadingState(fileName: event.fileName));

        // Directory? externalStorageDirectory = await getExternalStorageDirectory();
        // String musicPath = '${externalStorageDirectory!.path}/Music';
        //
        // await mediaDownloader.downloadFile(event.fileName, event.fileName, "", musicPath);

        // await mediaDownloader.downloadMedia(event.context, event.url);

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
      final List<Permission> permissions = [
        Permission.storage,
        Permission.manageExternalStorage,
        Permission.accessMediaLocation,
        Permission.mediaLibrary,
      ];

      await permissions.request();
    }
  }

  Future<void> _musicIsSuccessfullyDownloadedEvent(
      MusicIsSuccessfullyDownloadedEvent event,
      Emitter<DownloadMusicState> emit) async {
    emit(DownloadMusicSuccessState(fileName: event.fileName));
  }
}
