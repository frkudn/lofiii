

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../resources/my_assets/my_assets.dart';

class NoInternetLottieAnimation extends StatelessWidget {
  const NoInternetLottieAnimation({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        animate: true,
        MyAssets.lottieNoInternetAnimation,
        fit: BoxFit.contain,
        width: 0.4.sw,
        height: 0.4.sw,
      ),
    );
  }
}