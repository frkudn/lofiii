import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/menu_helper.dart';

class PlayerScreenMoreButtonWidget extends StatelessWidget {


   const PlayerScreenMoreButtonWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          MenuHelper.showMenuAtPosition(
              context: context,

              ///!---------       Position     ------------/////
              position: details.globalPosition,

              ///!------------------    Items     -------------////
              items: [
                // PopupMenuItem(
                //   child: BlocBuilder<CurrentlyPlayingMusicDataToPlayerCubit,
                //       FetchCurrentPlayingMusicDataToPlayerState>(
                //     builder: (context, fetchCurrentMusicState) {
                //       return BlocConsumer<DownloadMusicBloc,
                //           DownloadMusicState>(
                //         listener: (context, downloadState) {
                //             if(downloadState is DownloadMusicInProgressState){
                //               const CustomSnackBar.success(message: "Downloading is started");
                //             }
                //
                //             if (downloadState is DownloadMusicProgressState) {
                //               const CustomSnackBar.success(message: "Downloading is started");
                //               ScaffoldMessenger.of(context).showMaterialBanner(
                //                   MaterialBanner(
                //
                //                     content: ListTile(
                //                     title: const Text("Downloading..."),
                //                     subtitle: Text(
                //                         "Download Progress : ${downloadState
                //                             .progress}"),
                //                   ), actions: [],
                //                   ),
                //               );
                //           }
                //
                //             if(downloadState is DownloadMusicSuccessState){
                //               //! Close Material Banner when download completes
                //               ScaffoldMessenger.of(context)
                //                   .hideCurrentMaterialBanner();
                //             }
                //             if(downloadState is DownloadMusicFailureState){
                //               CustomSnackBar.error(message: downloadState.errorMessage);
                //             }
                //
                //         },
                //         builder: (context, state) {
                //           return ListTile(
                //               onTap: () {
                //                 Navigator.pop(context);
                //                 Navigator.pop(context);
                //                 context.read<DownloadMusicBloc>().add(
                //                     DownloadNowEvent(
                //                         url: fetchCurrentMusicState
                //                             .fullMusicList[
                //                                 fetchCurrentMusicState
                //                                     .musicIndex]
                //                             .url,
                //                         fileName: fetchCurrentMusicState
                //                             .fullMusicList[
                //                                 fetchCurrentMusicState
                //                                     .musicIndex]
                //                             .title));
                //               },
                //               leading: const Icon(FontAwesomeIcons.download),
                //               title: const Text("Download"));
                //         },
                //       );
                //     },
                //   ),
                // ),
                PopupMenuItem(
                    child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                              Text("Lyrics feature is currently not available"),
                        ),
                      ),
                    );
                  },
                  leading: const Icon(Icons.lyrics),
                  title: const Text("Lyrics"),
                )),
              ]);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert_rounded,
            color: CupertinoColors.white,
          ),
        ));
  }
}
