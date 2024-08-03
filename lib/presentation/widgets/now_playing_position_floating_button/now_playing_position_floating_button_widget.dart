


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/cubit/searchable_list_scroll_controller/download_scroll_controller_state.dart';
import '../../../logic/cubit/searchable_list_scroll_controller/searchableList_scroll_controller_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class NowPlayingPositionFloatingButtonWidget extends StatelessWidget {
  const NowPlayingPositionFloatingButtonWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        return BlocBuilder<SearchableListScrollControllerCubit,
            SearchableListScrollControllerState>(
          builder: (context, state) {
            return BounceInRight(
              child: Container(
                margin: EdgeInsets.only(bottom: 0.18.sh),
                child: IconButton(
                  onPressed: () {
                    final scrollController = locator.get<ScrollController>();
                    scrollController.jumpTo(state.scrollOffset);
                  },
                  icon: Icon(
                    Icons.mouse,
                    size: 30.sp,
                    color: Color(themeState.accentColor),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}