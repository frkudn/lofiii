import 'dart:developer';
import 'exports.dart';

void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeLocator(); // This should initialize all dependencies

  // Initialize Hive database and register custom adapters
  await MyHive.initializeHive();

  // Set up notification services
  await NotificationService().initNotification();

  // Set up JustAudioBackground services
  await NotificationService().initJustAUdioBackgroundNotification();

  // Load environment variables
  log('Loading environment variables');
  await dotenv.load();
  log('Environment variables loaded');

  // Enable wakelock to keep the screen on
  log('Enabling wakelock');
  WakelockPlus.enable();
  log('Wakelock enabled');

  // Set preferred screen orientations
  log('Setting preferred orientations');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  log('Preferred orientations set');

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
