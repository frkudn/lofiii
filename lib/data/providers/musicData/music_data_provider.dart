import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:lofiii/data/providers/musicData/music_data_keys.dart';
import 'package:lofiii/di/dependency_injection.dart';

class MusicDataProvider extends MusicDataKeys {
  final Dio _dio = locator.get<Dio>();

  ///?----        LOFIII  Music Data     ------------///
  Future<Map<String, dynamic>> fetchMusicData() async {
    try {
      log("Attempting to fetch music data from $lofiiiUrl");
      final response = await _dio.get(lofiiiUrl);
      log("Response status code: ${response.statusCode}");
      log("Response Data of LOFIII Music \n ${response.data}");
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII Music data: $e");
      throw Exception(e);
    }
  }
}
