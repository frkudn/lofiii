import 'exports.dart';

void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  initializeLocator();

  // Set up notification services
  NotificationService().initNotification();
  NotificationService().initJustAUdioBackgroundNotification();

  // Enable wakelock to keep the screen on
  WakelockPlus.enable();

  // Load environment variables
  await dotenv.load();

  // Initialize Hive database and register custom adapters
  await MyHive.initializeHive();
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(LofiiiArtistModelAdapter());

  // Set preferred screen orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Launch the application
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Clean up resources when the app is disposed
    locator.get<ScrollController>().dispose();
    locator.get<Floating>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: myBlocProviders(),
      // Initialize ScreenUtil for responsive design
      child: ScreenUtilInit(
        splitScreenMode: true,
        builder: (context, child) =>
            // Use BlocBuilder to react to theme changes
            BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            return MaterialApp(
              // Configure app theme based on current state
              theme: state.isDarkMode
                  ? AppThemes.darkTheme.copyWith(
                      // Adjust theme for black mode if active
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
                  : AppThemes.lightTheme,
              title: 'LOFIII',
              initialRoute: AppRoutes.splashRoute,
              onGenerateRoute: AppRouter.generateRoute,
              debugShowCheckedModeBanner: false,
              // Use OneContext for global access to BuildContext
              builder: OneContext().builder,
              navigatorKey: OneContext().key,
            );
          },
        ),
      ),
    );
  }
}
