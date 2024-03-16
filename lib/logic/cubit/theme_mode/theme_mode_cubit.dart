// ignore_for_file: depend_on_referenced_packages


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../resources/hive/hive_resources.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit()
      //! Initializing the ThemeModeCubit with the initial state based on the value retrieved from Hive.
      : super(
          ThemeModeState(
              isDarkMode:
                  MyHiveBoxes.settingBox.get(MyHiveKeys.darkModeHiveKey) ??
                      false,
              isBlackMode:
                  MyHiveBoxes.settingBox.get(MyHiveKeys.blackModeHiveKey) ??
                      false,
              accentColor: MyHiveBoxes.settingBox
                      .get(MyHiveKeys.themeAccentColorHiveKey)
                  ??
                  0XFFFF0090
          ),
        );

  //? Method to change the theme mode.
  changeThemeMode() async {
    //! Toggling the current theme mode.
    bool isDarkMode = !state.isDarkMode;
    //! Emitting the new theme mode state.
    emit(state.copyWith(isDarkMode: isDarkMode, isBlackMode: false));
    //! Updating the theme mode in Hive.
    MyHiveBoxes.settingBox.put(MyHiveKeys.darkModeHiveKey, isDarkMode);
    MyHiveBoxes.settingBox.put(MyHiveKeys.blackModeHiveKey, false);
  }

  changeIntoBlackMode() async {
    bool isBlackMode = !state.isBlackMode;
    emit(state.copyWith(isBlackMode: isBlackMode));
    MyHiveBoxes.settingBox.put(MyHiveKeys.blackModeHiveKey, isBlackMode);
  }


  changeAccentColor({required int? colorCode}){
    int? color = colorCode;
    if(color != null) {
      emit(state.copyWith(accentColor: color));
      MyHiveBoxes.settingBox.put(MyHiveKeys.themeAccentColorHiveKey, color);
    }
  }

  changeSelectedTileIndex({required index}){
    emit(state.copyWith(localMusicSelectedTileIndex: index));
  }
  
}
