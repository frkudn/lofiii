import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pod_player/pod_player.dart';

part 'youtube_music_player_state.dart';

class YoutubeMusicPlayerCubit extends Cubit<YoutubeMusicPlayerState> {
  Timer? _hideButtonsTimer;
  Timer? _showCurrentPositionOnHorizontalTimer;

  YoutubeMusicPlayerCubit() : super(YoutubeMusicPlayerInitialState());

  void initializePlayer({required videoId}) {
    emit(YoutubeMusicPlayerLoadingState());

    PodPlayerController controller = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
            videoQualityPriority: [1080, 720, 360],
            isLooping: false,
            autoPlay: true,
            wakelockEnabled: true,
            forcedVideoFocus: true),
        playVideoFrom: PlayVideoFrom.youtube(videoId))
      ..initialise();

    emit(YoutubeMusicPlayerSuccessState(
      controller: controller,
      screenLock: false,
      showPlayerButtons: false,
      showVideoPositionOnHDragging: false,
    ));
  }

  showCurrentPositionOnHorizontalDragging(
      {required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      
      emit(state.copyWith(showVideoPositionOnHDragging: true));

      // Cancel any previous timers
     _showCurrentPositionOnHorizontalTimer?.cancel();

      // Start a new timer to hide the buttons after 3 seconds
      _showCurrentPositionOnHorizontalTimer =
          Timer(const Duration(milliseconds: 3000), () {
        emit(state.copyWith(showVideoPositionOnHDragging: false));
      });
    }
  }

  showPlayerButtonsToggle({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      // If player buttons are already visible, don't reset the timer
      if (state.showPlayerButtons) return;

      // Show the player buttons
      emit(state.copyWith(showPlayerButtons: true));

      // Cancel any previous timers
      _hideButtonsTimer?.cancel();

      // Start a new timer to hide the buttons after 5 seconds
      _hideButtonsTimer = Timer(const Duration(seconds: 5), () {
        emit(state.copyWith(showPlayerButtons: false));
      });
    }
  }

  hidePlayerButtons({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      emit(state.copyWith(showPlayerButtons: false));
    }
  }

  screenLockToggle({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      emit(state.copyWith(screenLock: !state.screenLock));
    }
  }

  disposePlayer({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      state.controller.dispose();
    }
  }
}
