

import '../../di/dependency_injection.dart';
import '../datasources/musicData/music_data_api.dart';
import '../models/artist_model.dart';
import '../models/music_model.dart';

class MusicRepository {
  final MusicData musicData = locator.get<MusicData>();

  ///? ------------------             LOFIII Special Music    ---------------///
  Future<List<MusicModel>> fetchLOFIIISpecialMusic() async {
    final List<dynamic> musicList = await musicData.getLOFIIISpecialMusic();
    if (musicList.isNotEmpty) {
      return musicList.map((e) => MusicModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch LOFIII Special Music.");
    }
  }

  ///? ------------------             LOFIII Popular Music    ---------------///
  Future<List<MusicModel>> fetchLOFIIIPopularMusic() async {
    final List<dynamic> musicList = await musicData.getLOFIIIPopularMusic();
    if (musicList.isNotEmpty) {
      return musicList.map((e) => MusicModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch LOFIII Popular Music.");
    }
  }


  ///? ------------------             LOFIII TopPicks Music    ---------------///
  Future<List<MusicModel>> fetchLOFIIITopPicksMusic() async {
    final List<dynamic> musicList = await musicData.getLOFIIITopPicksMusic();
    if (musicList.isNotEmpty) {
      return musicList.map((e) => MusicModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch LOFIII TopPicks Music.");
    }
  }


  ///? ------------------             LOFIII Artists Images    ---------------///
  Future<List<ArtistModel>> fetchArtists() async {
    final List<dynamic> artistList = await musicData.getArtistsData();
    if (artistList.isNotEmpty) {
      return artistList.map((e) => ArtistModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch  Artists");
    }
  }



  ///? ------------------             LOFIII Vibes Music    ---------------///
  Future<List<MusicModel>> fetchLOFIIIVibesMusic() async {
    final List<dynamic> musicList = await musicData.getLOFIIIVibesMusic();
    if (musicList.isNotEmpty) {
      return musicList.map((e) => MusicModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch LOFIII Vibes Music.");
    }
  }
}
