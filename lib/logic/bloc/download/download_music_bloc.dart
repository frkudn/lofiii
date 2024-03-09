import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

part 'download_music_event.dart';
part 'download_music_state.dart';

class DownloadMusicBloc extends Bloc<DownloadMusicEvent, DownloadMusicState> {
  final MediaDownload mediaDownloader;

  DownloadMusicBloc({required this.mediaDownloader})
      : super(DownloadMusicInitialState()) {
    on<DownloadNowEvent>(_downloadNowEvent);
    on<MusicIsSuccessfullyDownloadedEvent>(_musicIsSuccessfullyDownloadedEvent);
  }

  Future<void> _downloadNowEvent(
      DownloadNowEvent event, Emitter<DownloadMusicState> emit) async {
    await mediaDownloader.requestPermission();

    try {
      emit(DownloadMusicLoadingState(fileName: event.fileName));

      await mediaDownloader.downloadMedia(
        event.context,
        event.url,
      );

      add(MusicIsSuccessfullyDownloadedEvent(fileName: event.fileName));

      await Future.delayed(const Duration(seconds: 10));
      emit(DownloadMusicInitialState());
    } catch (e) {
      emit(DownloadMusicFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _musicIsSuccessfullyDownloadedEvent(
      MusicIsSuccessfullyDownloadedEvent event,
      Emitter<DownloadMusicState> emit) async {
    emit(DownloadMusicSuccessState(fileName: event.fileName));
  }
}
