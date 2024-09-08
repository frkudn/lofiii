import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lofiii/presentation/pages/settings/exports.dart';
import '../../logic/cubit/bottom_navigation_change_page_index/bottom_navigation_index_cubit.dart';

class CustomBottomNavigationWidget extends StatelessWidget {
  CustomBottomNavigationWidget({super.key, required this.state});

  final BottomNavigationIndexState state;

  final _icons = <IconData>[
    EvaIcons.home,
    FontAwesomeIcons.youtube,
    CupertinoIcons.music_note_list,
    FontAwesomeIcons.solidFolder,
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
              child: GestureDetector(
                //------- Change Page Index on Scrolling
                onHorizontalDragEnd: (details) {
                  double? primaryDelta = details.primaryVelocity;
                  log("Bottom Nav Bar Horizontal Scrolling Primary Velocitys :\n$primaryDelta");
                  if (primaryDelta! > 100) {
                    if (bottomNavigationIndexState.pageIndex <= 3) {
                      context
                          .read<BottomNavigationIndexCubit>()
                          .changePageIndex(
                              index: bottomNavigationIndexState.pageIndex + 1);
                    }
                  }
                  if (primaryDelta < -100) {
                    if (bottomNavigationIndexState.pageIndex >= 1) {
                      context
                          .read<BottomNavigationIndexCubit>()
                          .changePageIndex(
                              index: bottomNavigationIndexState.pageIndex - 1);
                    }
                  }
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _icons.length,
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
                        icon: bottomNavigationIndexState.pageIndex == index
                            ? Swing(
                                child: Icon(
                                  _navIcons(
                                      bottomNavigationIndexState.pageIndex,
                                      index),
                                  color: bottomNavigationIndexState.pageIndex ==
                                          index
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                ),
                              )
                            : Icon(
                                _icons[index],
                                color: bottomNavigationIndexState.pageIndex ==
                                        index
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                              ),
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

  ///--------Change Icon on Index Changes
  _navIcons(bottomNavIndex, listIndex) {
    return bottomNavIndex == 0
        ? EvaIcons.homeOutline
        : bottomNavIndex == 1
            ? FontAwesomeIcons.squareYoutube
            : bottomNavIndex == 3
                ? FontAwesomeIcons.solidFolderOpen
                : bottomNavIndex == 4
                    ? EvaIcons.settingsOutline
                    : _icons[listIndex];
  }
}
