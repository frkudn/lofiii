part of 'theme_mode_cubit.dart';

@immutable

class ThemeModeState extends Equatable {
  const ThemeModeState({required this.isDarkMode, required this.isBlackMode, required this.accentColor});

  final bool isDarkMode;
  final bool isBlackMode;
  final int accentColor;

  ThemeModeState copyWith({isDarkMode, isBlackMode, accentColor}){
    return ThemeModeState(isDarkMode: isDarkMode?? this.isDarkMode, isBlackMode: isBlackMode?? this.isBlackMode, accentColor: accentColor?? this.accentColor);
}

  @override
  // TODO: implement props
  List<Object?> get props => [isDarkMode, isBlackMode,accentColor];
}

