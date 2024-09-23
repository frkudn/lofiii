import 'dart:async';
import 'dart:developer';

import 'package:lofiii/base/services/hive/hive_services.dart';
import '../models/lofiii_artist_model.dart';
import '../providers/musicData/music_data_provider.dart';
import '../models/music_model.dart';

class MusicRepository {
  static const String _dataKey = MyHiveKeys.cachedOnlineMusicHiveKey;
  static const String _lastFetchTimeKey =
      MyHiveKeys.onlineMusicLastFetchedTimeHiveKey;

  final MusicDataProvider _musicData = MusicDataProvider();

  Future<Map<String, dynamic>> _getFetchedData() async {
    final box = MyHiveBoxes.cachedManagerBox;
    final cachedData = box.get(_dataKey);

    if (cachedData == null ||
        MyHiveCheckCachesExpires.isOnlineMusicCacheExpired(
            olderThan: const Duration(days: 1))) {
      try {
        final Map<String, dynamic> newData = await _musicData.fetchMusicData();

        await Future.wait([
          box.put(_dataKey, newData),
          box.put(_lastFetchTimeKey, DateTime.now()),
        ]);

        log("Fetched and cached new data");
        return newData;
      } catch (e) {
        log("Error fetching data: $e");
        rethrow;
      }
    }

    log("Using cached data");
    if (cachedData is Map<String, dynamic>) {
      return cachedData;
    } else {
      log("Cached data is not of type Map<String, dynamic>, fetching new data");
      return await _musicData.fetchMusicData();
    }
  }

  Future<List<T>> _fetchData<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final fetchedData = await _getFetchedData();
      if (fetchedData.containsKey(key) && fetchedData[key] is List) {
        return (fetchedData[key] as List)
            .map((e) => e is Map<String, dynamic>
                ? fromJson(e)
                : throw FormatException('Invalid data format for key "$key"'))
            .toList();
      } else {
        throw Exception('Key "$key" not found or not a List in fetched data');
      }
    } catch (e) {
      log("Error in _fetchData: $e");
      rethrow;
    }
  }

  Future<List<MusicModel>> fetchLOFIIISpecialMusic() =>
      _fetchData("lofiispecialmusic", MusicModel.fromJson);

  Future<List<MusicModel>> fetchLOFIIIPopularMusic() =>
      _fetchData("lofiiipopularmusic", MusicModel.fromJson);

  Future<List<MusicModel>> fetchLOFIIITopPicksMusic() =>
      _fetchData("lofiiitoppicksmusic", MusicModel.fromJson);

  Future<List<MusicModel>> fetchLOFIIIVibesMusic() =>
      _fetchData("lofiiivibesmusic", MusicModel.fromJson);

  Future<List<LofiiiArtistModel>> fetchArtists() =>
      _fetchData("artists", LofiiiArtistModel.fromJson);
}
