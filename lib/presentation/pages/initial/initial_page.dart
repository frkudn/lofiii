import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bloc/check_internet_connection/check_internet_connection_bloc.dart';
import '../../../logic/cubit/bottom_navigation_change_page_index/bottom_navigation_index_cubit.dart';
import '../../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../../resources/hive/hive_resources.dart';
import '../../../utils/custom_snackbar.dart';
import '../../widgets/common/cutom_bottom_navigation_widget.dart';
import '../../widgets/mini_player/mini_player_widget.dart';
import '../downloads_page.dart';
import '../home_page.dart';
import '../library_page.dart';
import '../settings/settings.dart';
import '../youtube_music/youtube_music_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({
    super.key,
  });

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int backButtonPressCount = 0;


  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const YoutubeMusicPage(),
      const LibraryPage(),
      const DownloadsPage(),
      const SettingsPage()
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (backButtonPressCount == 0) {
          //! Change the page index to 0
          context.read<BottomNavigationIndexCubit>().changePageIndex(index: 0);
          backButtonPressCount++;
          //! Prevent the app from exiting
        } else {
          context.read<BottomNavigationIndexCubit>().changePageIndex(index: 0);
          //! Allow the app to exit;
          didPop;
        }
      },
      child: BlocListener<CheckInternetConnectionBloc,
          CheckInternetConnectionState>(
        listener: (context, state) {
          if (state is NoInternetConnectionState) {
            MyCustomSnackbars.showErrorSnackbar(context,
                message: "Please make sure your internet connection is on !");
          }
          // TODO: implement listener
        },
        child:
            BlocBuilder<BottomNavigationIndexCubit, BottomNavigationIndexState>(
          builder: (context, bottomNavState) {
            int index = bottomNavState.pageIndex;
            return Scaffold(
              body: Stack(fit: StackFit.expand, children: [
                ///!-----     Screens     ------///
                pages[index],

                ///!--------Show Mini Player First whenever music card is clicked
                BlocBuilder<ShowMiniPlayerCubit, ShowMiniPlayerState>(
                  builder: (context, state) {
                    return Visibility(
                        visible: state.showMiniPlayer,
                        child: FadeInUp(child: const MiniPlayerPageWidget()));
                  },
                ),

                ///!--------Custom Bottom Navigation Bar------/////
                CustomBottomNavigationWidget(state: bottomNavState),
              ]),
            );
          },
        ),
      ),
    );
  }

  ////!--------------- METHODS ----------------------///

}
