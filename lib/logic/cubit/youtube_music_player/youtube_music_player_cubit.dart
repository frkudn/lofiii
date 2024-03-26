import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:pod_player/pod_player.dart';
import 'package:signals/signals.dart';

part 'youtube_music_player_state.dart';

class YoutubeMusicPlayerCubit extends Cubit<YoutubeMusicPlayerState> {
  YoutubeMusicPlayerCubit() : super(YoutubeMusicPlayerInitialState());

  initializePlayer({required videoId}) async {
    final videoPosition = signal(0);
    final videoTotalDuration = signal(0);
    final videoState = signal(PodVideoState.loading);
    final videoIsBuffering = signal(true);

    emit(YoutubeMusicPlayerLoadingState());
    final controller = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          videoQualityPriority: [1080, 720, 480, 360, 240],
          isLooping: false,
          autoPlay: true,
          wakelockEnabled: true,
          forcedVideoFocus: true,
        ),
        playVideoFrom: PlayVideoFrom.youtube(videoId))
      ..initialise();

    controller.addListener(() {
      videoPosition.value = controller.currentVideoPosition.inSeconds;
      videoTotalDuration.value = controller.totalVideoLength.inSeconds;
      videoState.value = controller.videoState;
      videoIsBuffering.value = controller.isVideoBuffering;
    });

    emit(YoutubeMusicPlayerSuccessState(
        controller: controller,
        screenLock: false,
        showPlayerButtons: false,
        showVideoPositionOnHDragging: false,
        videoPosition: videoPosition,
        videoTotalDuration: videoTotalDuration,
        videoState: videoState,
        videoIsBuffering: videoIsBuffering));
  }

  showCurrentPositionOnHorizontalDragging(
      {required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      emit(state.copyWith(showVideoPositionOnHDragging: true));
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        emit(state.copyWith(showVideoPositionOnHDragging: false));
      });
    }
  }

  showPlayerButtons({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      emit(state.copyWith(showPlayerButtons: true));
      await Future.delayed(const Duration(seconds: 5)).then((value) {
        emit(state.copyWith(showPlayerButtons: false));
      });
    }
  }

  sreenLockToggle({required YoutubeMusicPlayerState state}) async {
    if (state is YoutubeMusicPlayerSuccessState) {
      emit(state.copyWith(screenLock: !state.screenLock));
    }
  }

  disposeThePlayer({required state}) {
    if (state is YoutubeMusicPlayerSuccessState) {
      state.controller.dispose();
    }
  }
}


