import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

part 'download_music_event.dart';
part 'download_music_state.dart';

class DownloadMusicBloc extends Bloc<DownloadMusicEvent, DownloadMusicState> {
  final Dio dio;
  DownloadMusicBloc({required this.dio}) : super(DownloadMusicInitialState()) {
    on<DownloadNowEvent>(_downloadNowEvent);
    on<MusicIsSuccessfullyDownloadedEvent>(_musicIsSuccessfullyDownloadedEvent);
  }

  ///!  DIO Code

  FutureOr<void> _downloadNowEvent(
      DownloadNowEvent event, Emitter<DownloadMusicState> emit) async {
    //! Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        emit(DownloadMusicLoadingState(fileName: event.fileName)); // Emitting in progress state

        //! Get downloads directory
        Directory? downloadsDir = await getDownloadsDirectory();
        downloadsDir ??= await getApplicationDocumentsDirectory();

        log(downloadsDir.path);
        //! Fetch content type
        // Response response = await dio.head(event.url);
        //
        // String contentType = response.headers.map['content-type']?[0] ?? 'mp3';

        // log("contentType : $contentType");
        //! Construct save path
        final savePath = '${downloadsDir.path}/${event.fileName.replaceAll(" ", "_").trim()}.mp3';

        log("savePath : $savePath");
        //! Download file
        await dio.download(
          event.url,
          savePath,
          deleteOnError: true,
          onReceiveProgress: (received, total) {
            final progress = (received / total * 100).toInt();

            emit(DownloadMusicProgressState(progress: progress));
          },
        );
        log("Downloaded Successfully : ${event.fileName}");
        add(MusicIsSuccessfullyDownloadedEvent(fileName: event.fileName));

        Future.delayed(const Duration(seconds: 5));
        emit(DownloadMusicInitialState());
      } catch (e) {
        emit(DownloadMusicFailureState(errorMessage: e.toString()));
      }
    } else {
      await Permission.storage.request().then((value) async {
        if (value.isGranted) {
          await Permission.accessMediaLocation.request();
        }
      });
    }
  }

  FutureOr<void> _musicIsSuccessfullyDownloadedEvent(
      MusicIsSuccessfullyDownloadedEvent event,
      Emitter<DownloadMusicState> emit) {
    emit(DownloadMusicSuccessState(fileName: event.fileName));
  }
}
