import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lofiii/data/models/lofiii_artist_model.dart';
import 'package:lofiii/data/models/music_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MyHive {
  static Future<void> initializeHive() async {
    try {
      log('Initializing Hive');
      //! Ensure Hive is initialized before using it
      final Directory appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);

      await Future.wait([
        //! Open the library box 
        Hive.openBox('library'),   
        //! Open the setting box
        Hive.openBox('setting'),
        //! Open the cache box
        Hive.openBox('cacheManager'),
      ]).then(
        (value) {
          MyHiveBoxes.libraryBox = value[0];
          MyHiveBoxes.settingBox = value[1];
          MyHiveBoxes.cachedManagerBox = value[2];
        },
      );

      log('Hive initialized');

      Hive.registerAdapter(MusicModelAdapter());
      Hive.registerAdapter(LofiiiArtistModelAdapter());
      log("Hive Adaptors 'MusicModelAdapter' & LofiiiArtistModelAdapter is registered ");
    } catch (e, stackTrace) {
      log('Hive initialization error: $e', stackTrace: stackTrace);
    }
  }

  static Color get themeAccentColor =>
      MyHiveBoxes.settingBox.get(MyHiveKeys.themeAccentColorHiveKey);
}

///!----------------    MyHive Boxes
class MyHiveBoxes {
  static late Box libraryBox;
  static late Box settingBox;
  static late Box cachedManagerBox;
}

///!---------------      MyHive Keys
class MyHiveKeys {
  static const String onlineFavoriteMusicListHiveKey =
      "hive_online_favorite_list";
  static const String localFavoriteMusicListHiveKey =
      "hive_local_favorite_list";
  static const String cachedLocalMusicListHiveKey =
      "cached_hive_local_music_list";
  static const String cachedOnlineMusicHiveKey =
      "cached_hive_online_music_list";
  static const String onlineMusicLastFetchedTimeHiveKey =
      "hive_online_music_last_fetched_time";
  static const String profilePicHiveKey = "hive_profile_pic";
  static const String profileUsernameHiveKey = "hive_username";
  static const String darkModeHiveKey = "hive_dark_mode";
  static const String blackModeHiveKey = "hive_black_mode";
  static const String themeAccentColorHiveKey = "hive_theme_accent_color";
  static const String showOnBoardingScreenHiveKey = "hive_show_on_boarding";
  static const String showMoreMusicMessageHiveKey =
      "hive_more_music_message_key";
}

class MyHiveClearCaches {
  /// Manually clears the cache
  /// Use this when you want to force a refresh of the data
  static Future<void> onlineMusicCache() async {
    final box = MyHiveBoxes.cachedManagerBox;
    await box.delete(MyHiveKeys.cachedOnlineMusicHiveKey);
    await box.delete(MyHiveKeys.onlineMusicLastFetchedTimeHiveKey);
  }
}

class MyHiveCheckCachesExpires {
  /// Checks if the cached data has expired
  static bool isOnlineMusicCacheExpired({required Duration olderThan}) {
    final box = MyHiveBoxes.cachedManagerBox;
    final lastFetchTime =
        box.get(MyHiveKeys.onlineMusicLastFetchedTimeHiveKey) as DateTime?;

    return lastFetchTime == null ||
        DateTime.now().difference(lastFetchTime) > olderThan;
  }
}
