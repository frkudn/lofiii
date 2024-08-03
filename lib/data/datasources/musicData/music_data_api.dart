import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lofiii/di/dependency_injection.dart';

import 'music_data_urls.dart';


class MusicData extends MusicDataKeys{
  final Dio _dio = locator.get<Dio>();


  ///?----        LOFIII Special Music     ------------///
  Future<List> getLOFIIISpecialMusic() async {
    try {
      final response = await _dio.get(lofiiiSpecialUrl);
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII Special Music: $e");
      return [];
    }
  }

  ///?----        LOFIII Popular Music     ------------///
  Future<List> getLOFIIIPopularMusic() async {
    try {
      final response = await _dio.get(lofiiiPopularUrl);
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII Popular Music: $e");
      return [];
    }
  }

  ///?----        LOFIII TopPicks Music     ------------///
  Future<List> getLOFIIITopPicksMusic() async {
    try {
      final response = await _dio.get(lofiiiTopPicksUrl);
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII TopPicks Music: $e");
      return [];
    }
  }


  ///?----        LOFIII Artists Data     ------------///
  Future<List> getArtistsData() async {
    try {
      final response = await _dio.get(artistsUrl);
      return response.data;
    } catch (e) {
      log("Error fetching Artists Data: $e");
      return [];
    }
  }



  ///?----        LOFIII Vibes Music     ------------///
  Future<List> getLOFIIIVibesMusic() async {
    try {
      final response = await _dio.get(lofiiiVibesUrl);
      return response.data;
    } catch (e) {
      log("Error fetching LOFIII Vibes Music: $e");
      return [];
    }
  }

}
