import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:volume_controller/volume_controller.dart';
import '../data/repositories/youtube_repository.dart';

GetIt locator = GetIt.instance;

initializeLocator() {
  try {
    locator.registerSingleton<Connectivity>(Connectivity());
    log('Connectivity registered');

    locator.registerSingleton<AudioPlayer>(AudioPlayer());
    log('AudioPlayer registered');

    locator.registerSingleton<VolumeController>(VolumeController());
    log('VolumeController registered');

    locator.registerSingleton<Dio>(Dio());
    log('Dio registered');

    locator.registerSingleton<ImagePicker>(ImagePicker());
    log('ImagePicker registered');

    locator.registerSingleton<FlipCardController>(FlipCardController());
    log('FlipCardController registered');

    locator.registerSingleton<OnAudioQuery>(OnAudioQuery());
    log('OnAudioQuery registered');

    locator.registerSingleton<ScrollController>(ScrollController());
    log('ScrollController registered');

    locator.registerSingleton<YouTubeDataRepository>(YouTubeDataRepository());
    log('YouTubeDataRepository registered');

    locator.registerSingleton<Floating>(Floating());
    log('Floating registered');

    log('Locator initialized');
  } catch (e, stackTrace) {
    log('Initialization error: $e', stackTrace: stackTrace);
  }
}
