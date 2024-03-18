import 'package:flutter/material.dart';



class Themes {
  ///----------Light Mode-------------///
  static final ThemeData lightTheme = ThemeData.light(useMaterial3: true)
      .copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
  );

  ///----------Dark Mode -----------------///
  static final ThemeData darkTheme = ThemeData.dark(useMaterial3: true)
      .copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),

  );
}
