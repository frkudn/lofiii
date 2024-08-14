// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import 'package:lofiii/presentation/common/mini_player_widget.dart';

class ViewMorePageMiniPlayerWidget extends StatelessWidget {
  const ViewMorePageMiniPlayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowMiniPlayerCubit, ShowMiniPlayerState>(
      builder: (context, state) {
        return Visibility(
            visible: state.showMiniPlayer,
            child: FadeInUp(
                child: MiniPlayerPageWidget(
              playerHeight: 0.1.sh,
              playerWidth: 1.sw,
              paddingBottom: 0.1,
              paddingTop: 0.0,
              bottomMargin: 0.0,
              playerAlignment: Alignment.bottomCenter,
              borderRadiusTopLeft: 0.0,
              borderRadiusTopRight: 0.0,
            )));
      },
    );
  }
}
