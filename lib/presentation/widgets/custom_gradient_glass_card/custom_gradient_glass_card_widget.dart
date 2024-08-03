


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class CustomGradientGlassCardWidget extends StatelessWidget {
  const CustomGradientGlassCardWidget({
    super.key,
    required this.child,
    this.height,
    this.width
  });

  final height;
  final width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Container(
          height:height?? 0.5.sh,
          width: width??0.8.sw,
          decoration: BoxDecoration(
            color:   themeState.isDarkMode?Colors.black.withOpacity(0.12):Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20)),

          child: child,
        );
      },
    );
  }
}