import 'package:flutter/cupertino.dart';
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
}
