

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/base/contents/contents.dart';


class DisclaimerMessageWidget extends StatelessWidget {
  const DisclaimerMessageWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.sp),
      width: 0.8.sw,
      child: Text(
        AppContents.disclaimerMessage,
        style:  TextStyle(color: Colors.white54, fontSize: 13.sp),
      ),
    );
  }
}