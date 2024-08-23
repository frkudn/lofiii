import '../../di/dependency_injection.dart';
import '../models/lofiii_artist_model.dart';
import '../providers/musicData/music_data_provider.dart';
import '../models/music_model.dart';

class MusicRepository {
  final MusicDataProvider musicData = locator.get<MusicDataProvider>();

  Future<List<MusicModel>> _fetchMusicData(String key) async {
    try {
      final Map<String, dynamic> fetchedData = await musicData.fetchMusicData();
      if (fetchedData.containsKey(key)) {
        return fetchedData[key].map((e) => MusicModel.fromJson(e)).toList();
      } else {
        throw Exception('Key not found in fetched data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LofiiiArtistModel>> fetchArtists() async {
    try {
      final Map<String, dynamic> fetchedData = await musicData.fetchMusicData();
      if (fetchedData.containsKey("artists")) {
        return fetchedData["artists"]
            .map((e) => LofiiiArtistModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Key not found in fetched data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MusicModel>> fetchLOFIIISpecialMusic() async =>
      _fetchMusicData("lofiiispecialmusic");

  Future<List<MusicModel>> fetchLOFIIIPopularMusic() async =>
      _fetchMusicData("lofiiipopularmusic");

  Future<List<MusicModel>> fetchLOFIIITopPicksMusic() async =>
      _fetchMusicData("lofiiitoppicksmusic");

  Future<List<MusicModel>> fetchLOFIIIVibesMusic() async =>
      _fetchMusicData("lofiiivibesmusic");
}
