import 'package:lofiii/base/router/app_routes.dart';
import 'package:lofiii/logic/providers/my_bloc_providers.dart';

import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///--- Initialize Get It
  initializeLocator();

  ///--- Initialize Notification
  NotificationService().initNotification();

  //----- Initialize Just Audio Background
  NotificationService().initJustAUdioBackgroundNotification();

  // The following line will enable the Android and iOS wakelock.
  WakelockPlus.enable();

  //!  Initialize Hive Database
  await MyHive.initializeHive();

  //! Setting preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    locator.get<ScrollController>().dispose();
    locator.get<Floating>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider for managing multiple BLoCs
    return MultiBlocProvider(
      providers: myBlocProviders(),

      //!     Initializing ScreenUtil for screen adaptation
      child: ScreenUtilInit(
        splitScreenMode: true,
        
        //!    Building the application with proper theme
        builder: (context, child) =>
            BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            return MaterialApp(
              ///!--- State is DarkMode
              theme: state.isDarkMode
                  ? AppThemes.darkTheme.copyWith(
                      ///!---  State is BlackMode
                      scaffoldBackgroundColor:
                          state.isBlackMode ? Colors.black : null,
                      primaryColor: state.isBlackMode ? Colors.black : null,
                      appBarTheme: AppBarTheme(
                          backgroundColor:
                              state.isBlackMode ? Colors.black : null),
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: Color(state.accentColor),
                          brightness: state.isDarkMode
                              ? Brightness.dark
                              : Brightness.light),
                    )
                  :

                  ///!---  State is not DarkMode
                  AppThemes.lightTheme,
              title: 'LOFIII',
              initialRoute: AppRoutes.splashRoute,
              onGenerateRoute: AppRouter.generateRoute,
              debugShowCheckedModeBanner: false,
              builder: OneContext().builder,
              navigatorKey: OneContext().key,
            );
          },
        ),
      ),
    );
  }
}
