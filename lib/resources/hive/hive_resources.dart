import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MyHive {
  static Future<void> initializeHive() async {
    //! Ensure Hive is initialized before using it
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    //! Open the library box
    MyHiveBoxes.libraryBox = await Hive.openBox('library');

    //! Open the setting box
    MyHiveBoxes.settingBox = await Hive.openBox('setting');
  }

  static Future<List<String>> getHiveFavoriteList() async {
    await initializeHive(); // Ensure Hive is initialized
    return MyHiveBoxes.libraryBox.get(MyHiveKeys.favoriteHiveKey) ?? [];
  }

  static List<String> favoriteMusicList =
      MyHiveBoxes.libraryBox.get(MyHiveKeys.favoriteHiveKey) ?? [];

  static Color get themeAccentColor => MyHiveBoxes.settingBox.get(MyHiveKeys.themeAccentColorHiveKey);
}

///!----------------    MyHive Boxes
class MyHiveBoxes {
  static late Box libraryBox;
  static late Box settingBox;
}

///!---------------      MyHive Keys
class MyHiveKeys {
  static const String favoriteHiveKey = "hive_favorite_list";
  static const String profilePicHiveKey = "hive_profile_pic";
  static const String profileUsernameHiveKey = "hive_username";
  static const String darkModeHiveKey = "hive_dark_mode";
  static const String blackModeHiveKey = "hive_black_mode";
  static const String themeAccentColorHiveKey = "hive_theme_accent_color";
  static const String showOnBoardingScreenHiveKey = "hive_show_on_boarding";
  static const String showMoreMusicMessageHiveKey = "hive_more_music_message_key";
}
