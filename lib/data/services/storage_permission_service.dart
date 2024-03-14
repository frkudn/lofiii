import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionService {
  static Future<bool> storagePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    log('releaseVersion : ${androidInfo.version.release}');
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      await Permission.manageExternalStorage.request();
      await Permission.photos.request();
      await Permission.videos.request();
      await Permission.audio.request();
      await Permission.notification.request();
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
