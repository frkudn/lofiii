import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../logic/cubit/bottom_navigation_change_page_index/bottom_navigation_index_cubit.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';

class CustomBottomNavigationWidget extends StatelessWidget {
  CustomBottomNavigationWidget({super.key, required this.state});

  final BottomNavigationIndexState state;

  final _icons = <IconData>[
    EvaIcons.home,
    FontAwesomeIcons.youtube,
    CupertinoIcons.music_note_list,
    EvaIcons.download,
    EvaIcons.settings
  ];


  @override
  Widget build(BuildContext context) {
    final bottomNavigationIndexState = state;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shadowColor: Colors.black38,
        // shadowColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(bottom: 0.01.sh),
              height: 0.08.sh,
              width: 0.85.sw,
              decoration: BoxDecoration(
                  color: state.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                ///Check Here
                itemBuilder: (context, index) => Container(
                  width: 0.17.sw,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: state.isDarkMode
                        ? bottomNavigationIndexState.pageIndex == index
                            ? Color(state.accentColor)
                            : Colors.transparent
                        : bottomNavigationIndexState.pageIndex == index
                            ? Color(state.accentColor)
                            : Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<BottomNavigationIndexCubit>()
                            .changePageIndex(index: index);
                      },
                      icon: Icon(
                        _icons[index],
                        color: bottomNavigationIndexState.pageIndex == index
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
