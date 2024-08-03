


import
'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';




class HeadingWithViewMoreButton extends StatelessWidget {
  const HeadingWithViewMoreButton({super.key, required this.heading,required this.viewMoreOnTap});

  final String heading;
  final VoidCallback viewMoreOnTap;
  @override
  Widget build(BuildContext context) {
    return   SliverPadding(
      padding: EdgeInsets.fromLTRB(12.w, 5.h, 12.w, 5.h),

      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(heading, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, letterSpacing: 1,fontFamily: "Poppins"),),

            BlocBuilder<ThemeModeCubit, ThemeModeState>(
  builder: (context, state) {
    return TextButton(onPressed: viewMoreOnTap, child: Text("View More>", style: TextStyle( fontSize: 10.sp, color: Color(state.accentColor)),),);
  },
),
          ],
        ),
      ),
    );
  }
}

