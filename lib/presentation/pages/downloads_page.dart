
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../resources/my_assets/my_assets.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            children: [
              Lottie.asset(MyAssets.lottieWorkInProgressAnimation),
              const Text("The download feature will be accessible in the forthcoming stable version.\n Stay Tuned", textAlign: TextAlign.center,),
            ],
          ),
        )
      ),
    );
  }
}
