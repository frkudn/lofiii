import '../exports.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int backButtonPressCount = 0;

  int initializeMusic = 0;

  @override
  void initState() {
    super.initState();
    if (initializeMusic == 0) {
      context
          .read<FetchMusicFromLocalStorageBloc>()
          .add(FetchMusicFromLocalStorageInitializationEvent());
      context
          .read<FetchFavoriteMusicFromLocalStorageBloc>()
          .add(FetchFavoriteMusicFromLocalStorageInitializationEvent());
      initializeMusic = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const YouTubeHomePage(),
      const LibraryPage(),
      const DownloadsPage(),
      const SettingsPage()
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
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
}
