import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lofiii/logic/cubit/addLocalMusicToFavorite/add_local_music_to_favorite_music_list_cubit.dart';
import 'package:lofiii/utils/custom_snackbar.dart';
import 'package:lofiii/utils/format_duration.dart';
import 'package:lofiii/utils/menu_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../logic/cubit/searchable_list_scroll_controller/download_scroll_controller_state.dart';
import '../../logic/cubit/searchable_list_scroll_controller/searchableList_scroll_controller_cubit.dart';

class MoreMusicButtonWidget extends StatefulWidget {
  const MoreMusicButtonWidget({
    required this.song,
  });

  final SongModel song;
  @override
  State<MoreMusicButtonWidget> createState() => _MoreMusicButtonWidgetState();
}

class _MoreMusicButtonWidgetState extends State<MoreMusicButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchableListScrollControllerCubit,
        SearchableListScrollControllerState>(
      builder: (context, state) {
        return BlocConsumer<LocalMusicToFavoriteMusicListCubit,
            LocalMusicToFavoriteMusicListState>(
          listener: (context, favoriteState) {
            if (favoriteState
                is LocalMusicToFavoriteMusicListIsSuccessfullyAddedState) {
              MyCustomSnackbars.showSimpleSnackbar(context,
                  message: "Music is added to Favorite");
            }

            if(favoriteState is LocalMusicToFavoriteMusicListIsAlreadyExistsState){
               MyCustomSnackbars.showSimpleSnackbar(context,
                  message: "Music is already added to Favorite");
            }

            if (favoriteState
                is LocalMusicToFavoriteMusicListIsSuccessfullyRemovedState) {
              MyCustomSnackbars.showSimpleSnackbar(context,
                  message: "Music is removed from Favorite");
            }

            if (favoriteState is LocalMusicToFavoriteMusicListFailureState) {
              MyCustomSnackbars.showErrorSnackbar(context,
                  message: favoriteState.errorMessage);
            }
          },
          builder: (context, lFState) {
            return GestureDetector(
              onTapDown: (TapDownDetails details) {
             

                final offset = details.globalPosition;
                setState(() {
                  MenuHelper.showMenuAtPosition(
                      context: context,
                      position: offset,
                      items: [
                          PopupMenuItem(
                            onTap: () {
                              context
                                  .read<LocalMusicToFavoriteMusicListCubit>()
                                  .addMusicToFavorite(widget.song.title);
                            },
                            child: const ListTile(
                              title: Text(
                                "Add to Favorite",
                              ),
                              trailing: Icon(Icons.favorite),
                            ),
                          ),
                        PopupMenuItem(
                          onTap: () {},
                          child: const ListTile(
                            title: Text(
                              "Rename",
                            ),
                            trailing: Icon(Icons.text_snippet),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {},
                          child: const ListTile(
                            title: Text(
                              "Delete",
                            ),
                            trailing: Icon(Icons.delete),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {},
                          child: const ListTile(
                            title: Text(
                              "Set as ringtone",
                            ),
                            trailing: Icon(Icons.call),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: _showMusicInfoDialog,
                          child: const ListTile(
                            title: Text(
                              "Music Info",
                            ),
                            trailing: Icon(Icons.info),
                          ),
                        ),
                      ]);
                });
              },
              child: const Icon(Icons.more_vert),
            );
          },
        );
      },
    );
  }

  _showMusicInfoDialog() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
              alignment: Alignment.center,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(CupertinoIcons.back),
                        ),
                      ),
                    ),
                    Text(
                      "  Music Info",
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    const Gap(10),
                    MusicInfoListTileWidget(
                        title: "Title", subtitle: widget.song.title),
                    MusicInfoListTileWidget(
                        title: "Artists",
                        subtitle: widget.song.artist ?? "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Composer",
                        subtitle: widget.song.composer ?? "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Genre",
                        subtitle: widget.song.genre ?? "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Album",
                        subtitle: widget.song.album ?? "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Music Extension",
                        subtitle: widget.song.fileExtension),
                    MusicInfoListTileWidget(
                        title: "Duration",
                        subtitle: FormatDuration.format(
                            Duration(milliseconds: widget.song.duration!))),
                    MusicInfoListTileWidget(
                        title: "Date Added",
                        subtitle: _formatDateTime(widget.song.dateAdded) ??
                            "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Date Modified",
                        subtitle: _formatDateTime(widget.song.dateModified) ??
                            "Unknown"),
                    MusicInfoListTileWidget(
                        title: "Music Location",
                        subtitle: widget.song.uri ?? "Unknown"),
                  ],
                ),
              ),
            ));
  }

  _formatDateTime(int? t) {
    if (t == null) {
      return "Invalid Date";
    }

    // Assuming the timestamp is in seconds, convert it to milliseconds
    final dateTime = DateTime.fromMillisecondsSinceEpoch(t * 1000);

    // Format the date as you wish
    String formattedDate = DateFormat.yMMMEd().format(dateTime);

    return formattedDate;
  }
}

class MusicInfoListTileWidget extends StatelessWidget {
  const MusicInfoListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      title: Text(
        subtitle,
        style: TextStyle(fontSize: 15.sp),
      ),
    );
  }
}
