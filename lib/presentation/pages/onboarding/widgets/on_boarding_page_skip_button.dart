// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/base/router/app_routes.dart';

import '../../../../base/services/app_permissions_service.dart';
import '../../../../base/services/hive/hive_services.dart';

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
            await AppPermissionService.allPermission();

            ///---! Don't Show this screen after restarting app
            MyHiveBoxes.settingBox
                .put(MyHiveKeys.showOnBoardingScreenHiveKey, false);

            Navigator.pushNamed(context, AppRoutes.initialRoute);
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
