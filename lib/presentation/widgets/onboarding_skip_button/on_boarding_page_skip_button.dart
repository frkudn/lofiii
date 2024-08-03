// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';

import '../../../data/services/app_permissions_service.dart';
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

         await AppPermissionService.storagePermission();

            ///---! Don't Show this screen after restarting app
            MyHiveBoxes.settingBox
                .put(MyHiveKeys.showOnBoardingScreenHiveKey, false);

         OneContext().pushReplacement(
              MaterialPageRoute(
                builder: (context) =>  InitialPage(),
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
