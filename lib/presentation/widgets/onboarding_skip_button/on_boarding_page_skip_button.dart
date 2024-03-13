// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/services/storage_permission_service.dart';
import '../../../resources/hive/hive_resources.dart';
import '../../pages/initial/initial_page.dart';

class OnBoardingSkipButton extends StatelessWidget {
  const OnBoardingSkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 40.sp),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () async {

         await StoragePermissionService.storagePermission();

            ///---! Don't Show this screen after restarting app
            MyHiveBoxes.settingBox
                .put(MyHiveKeys.showOnBoardingScreenHiveKey, false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InitialPage(),
              ),
            );
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
