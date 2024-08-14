import 'dart:developer';

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
      log("Failed to initialize background execution");
    }
  } else {
    log("Background permissions not granted");
  }
}
