import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/exports.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';
import 'package:shimmer/shimmer.dart';

class ListViewShimmerBoxWidget extends StatelessWidget {
  const ListViewShimmerBoxWidget(
      {super.key,
      this.itemHeight,
      this.itemWidth,
      this.boxHeight,
      this.boxWidth,
      this.scrollDirection,
      this.showHeader});

  final double? itemHeight;
  final double? itemWidth;

  final double? boxHeight;
  final double? boxWidth;
  final Axis? scrollDirection;
  final bool? showHeader;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return Shimmer.fromColors(
          baseColor: themeState.isDarkMode?Colors.grey[300]!.withOpacity(0.5) : Colors.grey[300]!,
          highlightColor:themeState.isDarkMode? Colors.grey[100]!.withOpacity(0.5):Colors.grey[100]! ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //---- Header Title-----////
              if (showHeader ?? true)
                Container(
                  width: 0.9.sw,
                  height: 0.04.sh,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              SizedBox(height: 10.h),

              ///------------List ------------///
              SizedBox(
                height: boxHeight ?? 0.25.sh,
                width: boxWidth ?? 1.sw,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: scrollDirection ?? Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: itemWidth ?? 0.35.sw, // Full width
                      height: itemHeight ?? 0.27.sh, // 0.25 of screen height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
