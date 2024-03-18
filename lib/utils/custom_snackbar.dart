import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class MyCustomSnackbars {
 static void showErrorSnackbar(context, {required String message}) {
    showTopSnackBar(
      animationDuration: const Duration(seconds: 3),
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
      ),
    );
  }



 static void showSimpleSnackbar(context, {required String message}) {
   showTopSnackBar(
     animationDuration: const Duration(seconds: 3),
     Overlay.of(context),
     CustomSnackBar.info(
       message: message,
     ),
   );
 }


 static void showInfoSnackbar(context, {required String message, Icon? icon}) {
   showTopSnackBar(
     animationDuration: const Duration(seconds: 10),
     Overlay.of(context),
     CustomSnackBar.info(
       message: message,
       backgroundColor: Colors.pink,
       icon: icon??const Icon(CupertinoIcons.info),
       iconPositionLeft: 0.04.sw,
       textAlign: TextAlign.center,
       textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
     ),
   );
 }
}
