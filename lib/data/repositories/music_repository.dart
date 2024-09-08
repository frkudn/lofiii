import 'dart:async';
import 'dart:developer';

import '../models/lofiii_artist_model.dart';
import '../providers/musicData/music_data_provider.dart';
import '../models/music_model.dart';

class MusicRepository {
  final MusicDataProvider musicData = MusicDataProvider();

  Future<List<MusicModel>> _fetchMusicData(String key) async {
    try {
      Map<String, dynamic> fetchedData = await musicData.fetchMusicData();

      log("\nFetch Data Map is :\n $fetchedData");

      // Print all keys in the map
      fetchedData.keys.forEach(
        (element) => log("\nAll keys are here : \n $element"),
      );

      // Check if the key exists
      if (fetchedData.containsKey(key)) {
        // If the key exists, return the corresponding value
        return fetchedData[key]
            .map((e) => MusicModel.fromJson(e))
            .toList()
            .cast<MusicModel>();
      } else {
        // If the key doesn't exist, throw an exception
        throw Exception('Key not found in fetched data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LofiiiArtistModel>> fetchArtists() async {
    try {
      Map<String, dynamic> fetchedData = await musicData.fetchMusicData();
      if (fetchedData.containsKey("artists")) {
        return fetchedData["artists"]
            .map((e) => LofiiiArtistModel.fromJson(e))
            .toList()
            .cast<LofiiiArtistModel>();
      } else {
        throw Exception('Artists Key not found in fetched data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MusicModel>> fetchLOFIIISpecialMusic() async =>
      _fetchMusicData("lofiispecialmusic");

  Future<List<MusicModel>> fetchLOFIIIPopularMusic() async =>
      _fetchMusicData("lofiiipopularmusic");

  Future<List<MusicModel>> fetchLOFIIITopPicksMusic() async =>
      _fetchMusicData("lofiiitoppicksmusic");

  Future<List<MusicModel>> fetchLOFIIIVibesMusic() async =>
      _fetchMusicData("lofiiivibesmusic");
}
