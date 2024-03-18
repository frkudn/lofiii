// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../di/dependency_injection.dart';

// Importing event and state classes.
part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final audioPlayer = locator.get<AudioPlayer>();

  //! Constructor for the MusicPlayerBloc class, initializing it with AudioPlayer instance.
  MusicPlayerBloc()
      : super(MusicPlayerLoadingState()) {
    on<MusicPlayerInitializeEvent>(_musicPlayerInitializeEvent);
    on<MusicPlayerTogglePlayPauseEvent>(_musicPlayerTogglePlayPauseEvent);
    on<MusicPlayerSeekEvent>(_musicPlayerSeekEvent);
    on<MusicPlayerStopEvent>(_musicPlayerStopEvent);
    on<MusicPlayerRepeatEvent>(_musicPlayerRepeatEvent);
    on<MusicPlayerShuffleEvent>(_musicPlayerShuffleEvent);
    on<MusicPlayerVolumeSetEvent>(_musicPlayerVolumeSetEvent);
    on<MusicPlayerForwardEvent>(_musicPlayerForwardEvent);
    on<MusicPlayerBackwardEvent>(_musicPlayerBackwardEvent);
  }

  //! Method to handle MusicPlayerInitializeEvent and Play Music.
  FutureOr<void> _musicPlayerInitializeEvent(
      MusicPlayerInitializeEvent event, Emitter<MusicPlayerState> emit) async {
    try {
      emit(MusicPlayerLoadingState());
      audioPlayer.setUrl(
        event.url.toString(),
        preload: true,
      );
      audioPlayer.play();

      //! Combine the position and duration and Buffered streams
      final combinedStream = Rx.combineLatest3(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        audioPlayer.bufferedPositionStream,
        (position, duration, buffered) => [position, duration, buffered],
      ).publish().autoConnect();
      
      

      emit(MusicPlayerSuccessState(
        positionStream: audioPlayer.positionStream,
        durationStream: audioPlayer.durationStream,
        playingStream: audioPlayer.playingStream,
        audioPlayer: audioPlayer,
        combinedStreamPositionAndDurationAndBufferedList: combinedStream,
      ));
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerTogglePlayPauseEvent.
  FutureOr<void> _musicPlayerTogglePlayPauseEvent(
      MusicPlayerTogglePlayPauseEvent event, Emitter<MusicPlayerState> emit) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  // Method to handle MusicPlayerSeekEvent.
  FutureOr<void> _musicPlayerSeekEvent(
      MusicPlayerSeekEvent event, Emitter<MusicPlayerState> emit) {
    try {
      audioPlayer.seek(Duration(seconds: event.position));
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerStopEvent.
  FutureOr<void> _musicPlayerStopEvent(
      MusicPlayerStopEvent event, Emitter<MusicPlayerState> emit) {
    audioPlayer.stop();
  }

  // Method to handle MusicPlayerRepeatEvent.
  FutureOr<void> _musicPlayerRepeatEvent(
      MusicPlayerRepeatEvent event, Emitter<MusicPlayerState> emit) {
    switch (audioPlayer.loopMode) {
      case LoopMode.off:
        audioPlayer.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
      default:
        audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  // Method to handle MusicPlayerShuffleEvent.
  FutureOr<void> _musicPlayerShuffleEvent(
      MusicPlayerShuffleEvent event, Emitter<MusicPlayerState> emit) {
    if (audioPlayer.shuffleModeEnabled == false) {
      audioPlayer.setShuffleModeEnabled(true);
    } else {
      audioPlayer.setShuffleModeEnabled(false);
    }
  }

  FutureOr<void> _musicPlayerVolumeSetEvent(
      MusicPlayerVolumeSetEvent event, Emitter<MusicPlayerState> emit) {
    audioPlayer.setVolume(event.volumeLevel);
  }

  FutureOr<void> _musicPlayerForwardEvent(
      MusicPlayerForwardEvent event, Emitter<MusicPlayerState> emit) {
    audioPlayer.seek(Duration(seconds: audioPlayer.position.inSeconds+5));
  }




  FutureOr<void> _musicPlayerBackwardEvent(MusicPlayerBackwardEvent event, Emitter<MusicPlayerState> emit) {
    audioPlayer.seek(Duration(seconds: audioPlayer.position.inSeconds-5));
  }
}
