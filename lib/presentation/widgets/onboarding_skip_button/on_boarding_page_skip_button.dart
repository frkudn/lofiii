// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

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
            if (!(await Permission.storage.isGranted)) {
              await Permission.storage.request();
            }
            if (!(await Permission.manageExternalStorage.isGranted)) {
              await Permission.manageExternalStorage.request();
            }
            if (!(await Permission.accessMediaLocation.isGranted)) {
              await Permission.accessMediaLocation.request();
            }
            if (!(await Permission.notification.isGranted)) {
              await Permission.notification.request();
            }

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
