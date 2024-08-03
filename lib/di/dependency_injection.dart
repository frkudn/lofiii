

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
import 'package:youtube_scrape_api/youtube_scrape_api.dart';
import '../data/datasources/musicData/music_data_api.dart';
import '../data/repositories/youtube_repository.dart';

final GetIt locator = GetIt.instance;


void initializeLocator(){
  locator.registerSingleton<Connectivity>(Connectivity());
  locator.registerSingleton<AudioPlayer>(AudioPlayer());
  locator.registerSingleton<VolumeController>(VolumeController());
  locator.registerSingleton<Dio>(Dio());
  locator.registerSingleton<ImagePicker>(ImagePicker());
  locator.registerSingleton<FlipCardController>(FlipCardController());
  locator.registerSingleton<OnAudioQuery>(OnAudioQuery());
  locator.registerSingleton<MusicData>(MusicData());
  locator.registerSingleton<ScrollController>(ScrollController());
  locator.registerSingleton<YoutubeDataApi>(YoutubeDataApi());
  locator.registerSingleton<YouTubeDataRepository>(YouTubeDataRepository());
  locator.registerSingleton<Floating>(Floating());

}