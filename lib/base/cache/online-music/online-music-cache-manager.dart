import 'package:hive/hive.dart';
import 'package:lofiii/data/models/music_model.dart';
import 'package:lofiii/exports.dart';

class OnlineMusicCacheManager {
  final Box _cachedBox = MyHiveBoxes.cachedOnlineMusicBox;
  final String _key = MyHiveKeys.cachedOnlineMusicListHiveKey;

  Future<List<MusicModel>?> getLocalMusic() async {
    return await _cachedBox.get(_key);
  }

  updateLocalMusic({required List<MusicModel> data}) async {
    await _cachedBox.put(_key, data);
  }

  deleteLocalMusic() async {
    await _cachedBox.delete(_key);
  }
}
