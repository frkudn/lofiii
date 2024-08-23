import 'package:lofiii/exports.dart';
import 'package:lofiii/presentation/pages/downloads/exports.dart';

class AppThemes {

  
  
  ///----------Light Mode-------------///
  static final ThemeData lightTheme =
      ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
    scrollbarTheme: ScrollbarThemeData(

        interactive: true,
        crossAxisMargin: 8.sp,
        minThumbLength: 0.15.sh,
        thickness: WidgetStatePropertyAll(13.sp),
        radius: const Radius.circular(20),
        mainAxisMargin: 8.sp),
  );

  ///----------Dark Mode -----------------///
  static final ThemeData darkTheme =
      ThemeData.dark(useMaterial3: true).copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
    scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        crossAxisMargin: 8.sp,
        minThumbLength: 0.15.sh,
        thickness: WidgetStatePropertyAll(13.sp),
        radius: const Radius.circular(20),
        mainAxisMargin: 8.sp),
  );
}
