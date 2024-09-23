// ignore_for_file: prefer_typing_uninitialized_variables

part of 'theme_mode_cubit.dart';

@immutable
class ThemeModeState extends Equatable {
  const ThemeModeState(
      {required this.isDarkMode,
      required this.isBlackMode,
      required this.accentColor,
      this.localMusicSelectedTileIndex,
      required this.sliderTrackHeight});

  final bool isDarkMode;
  final bool isBlackMode;
  final int accentColor;
  final double sliderTrackHeight;
  final localMusicSelectedTileIndex;

  ThemeModeState copyWith(
      {isDarkMode,
      isBlackMode,
      accentColor,
      localMusicSelectedTileIndex,
      sliderTrackHeight}) {
    return ThemeModeState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        isBlackMode: isBlackMode ?? this.isBlackMode,
        accentColor: accentColor ?? this.accentColor,
        sliderTrackHeight: sliderTrackHeight ?? this.sliderTrackHeight,
        localMusicSelectedTileIndex:
            localMusicSelectedTileIndex ?? this.localMusicSelectedTileIndex);
  }

  @override
  List<Object?> get props =>
      [isDarkMode, isBlackMode, accentColor, localMusicSelectedTileIndex, sliderTrackHeight];
}
