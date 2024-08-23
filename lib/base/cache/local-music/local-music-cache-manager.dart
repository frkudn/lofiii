import 'package:hive/hive.dart';
import 'package:lofiii/exports.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';

class LocalMusicCacheManager {
  final Box _cachedBox = MyHiveBoxes.cachedLocalMusicBox;
  final String _key = MyHiveKeys.cachedLocalMusicListHiveKey;

  Future<List<LocalMusicModel>?> getLocalMusic() async {
    return await _cachedBox.get(_key);
  }

  updateLocalMusic({required List<LocalMusicModel> data}) async {
    await _cachedBox.put(_key, data);
  }

  deleteLocalMusic() async {
    await _cachedBox.delete(_key);
  }
}
