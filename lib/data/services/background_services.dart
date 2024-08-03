import 'package:flutter_background/flutter_background.dart';

Future<void> initializeBackgroundExecution() async {
  
  bool hasBackgroundPermissions = await FlutterBackground.hasPermissions;

  if (hasBackgroundPermissions) {
    // Configuration for Android background execution
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );

    // Initialize background execution
    bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

    if (success) {
      FlutterBackground.enableBackgroundExecution();
    } else {
      print("Failed to initialize background execution");
    }
  } else {
    print("Background permissions not granted");
  }
}
