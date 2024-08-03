import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ListViewShimmerBoxWidget extends StatelessWidget {
  ListViewShimmerBoxWidget(
      {super.key,
      this.itemHeight,
      this.itemWidth,
      this.boxHeight,
      this.boxWidth, this.scrollDirection});

  double? itemHeight;
  double? itemWidth;

  double? boxHeight;
  double? boxWidth;
  Axis? scrollDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 0.9.sw,
              height: 0.04.sh,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(height: 10.h),
            Container(
              height: boxHeight ?? 0.25.sh,
              width: boxWidth ?? 1.sw,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: scrollDirection?? Axis.horizontal,
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
      ),
    );
  }
}
