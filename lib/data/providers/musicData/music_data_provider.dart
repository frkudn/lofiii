import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lofiii/data/providers/musicData/music_data_keys.dart';
import 'package:lofiii/di/dependency_injection.dart';

class MusicDataProvider extends MusicDataKeys {
  final Dio _dio = locator.get<Dio>();

  ///?----        LOFIII  Music Data     ------------///
  Future<Map<String, dynamic>> fetchMusicData() async {
    try {
      final response = await _dio.get(lofiiiUrl);
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII Special Music: $e");
      throw Exception(e);
    }
  }
}
