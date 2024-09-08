import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lofiii/base/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  static Future<bool> allPermission() async {
    log("Requesting for all Permissions \n");
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;

    log('Android releaseVersion : \n${androidInfo.version.release}');
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      if (await Permission.phone.status != PermissionStatus.granted) {
        await Permission.photos.request();
        log("Photos Permission is granted!");
      }
      if (await Permission.videos.status != PermissionStatus.granted) {
        await Permission.videos.request();
        log(" Videos Permission is granted!");
      }
      if (await Permission.audio.status != PermissionStatus.granted) {
        await Permission.audio.request();
        log("Audio Permission is granted!");
      }
      if (await Permission.manageExternalStorage.status !=
          PermissionStatus.granted) {
        await Permission.manageExternalStorage.request();
        log("Manage External Storage Permission is granted!");
      }
      if (await Permission.notification.status != PermissionStatus.granted) {
        await NotificationService()
            .notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        log("Notification Permission is granted!");
      }

      final status = await Permission.manageExternalStorage.status;
      havePermission = status.isGranted;
    } else {
      if (await Permission.notification.status != PermissionStatus.granted) {
        await NotificationService()
            .notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        log("Notification Permission is granted!");
      }
      // await Permission.ignoreBatteryOptimizations.request();
      if (await Permission.storage.status != PermissionStatus.granted) {
        await Permission.storage.request();
        log("Storage Permission is granted!");
      }

      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }

    return havePermission;
  }
}
