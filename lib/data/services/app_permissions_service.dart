import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lofiii/data/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  static Future<bool> storagePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    log('releaseVersion : ${androidInfo.version.release}');
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;


    if (androidVersion >= 13) {

      await Permission.photos.request();
      await Permission.videos.request();
      await Permission.audio.request();

      await Permission.manageExternalStorage.request();
      NotificationService().notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      final status = await Permission.manageExternalStorage.status;
      havePermission = status.isGranted;
    } else {
      await Permission.notification.request();
      await Permission.storage.request();
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }

    return havePermission;
  }
}
