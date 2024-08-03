import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/cubit/theme_mode/theme_mode_cubit.dart';

class MySliverAppBarPersistentDelegate extends SliverPersistentHeaderDelegate {
  MySliverAppBarPersistentDelegate(
      {required this.imageUrl, required this.artistName});

  final String imageUrl;
  final String artistName;


  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return Container(
          height: 0.4.sh, // Adjust this height as needed
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(state.accentColor),

            ///!---------------------      Artist Image
            image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [

              ///-----------!            Artist Name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(color: Colors.white,
                          fontSize: 25.sp,
                          shadows: const [
                            Shadow(color: Colors.black38, blurRadius: 5,)
                          ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 0.4.sh; // Adjust this height as needed

  @override
  double get minExtent => 0.1.sh; // Adjust this height as needed

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
