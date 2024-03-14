part of 'theme_mode_cubit.dart';

@immutable

class ThemeModeState extends Equatable {
  const ThemeModeState({required this.isDarkMode, required this.isBlackMode, required this.accentColor, this.localMusicSelectedTileIndex});

  final bool isDarkMode;
  final bool isBlackMode;
  final int accentColor;
  final localMusicSelectedTileIndex;

  ThemeModeState copyWith({isDarkMode, isBlackMode, accentColor, localMusicSelectedTileIndex}){
    return ThemeModeState(isDarkMode: isDarkMode?? this.isDarkMode, isBlackMode: isBlackMode?? this.isBlackMode, accentColor: accentColor?? this.accentColor,localMusicSelectedTileIndex: localMusicSelectedTileIndex??this.localMusicSelectedTileIndex);
}

  @override
  // TODO: implement props
  List<Object?> get props => [isDarkMode, isBlackMode,accentColor, localMusicSelectedTileIndex];
}

