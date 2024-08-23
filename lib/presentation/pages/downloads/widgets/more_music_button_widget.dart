import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lofiii/data/models/local_music_model.dart';
import 'package:lofiii/logic/bloc/fetch_favorite_music_from_local_storage/fetch_favorite_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/cubit/localMusicToFavorite/local_music_to_favorite_music_list_cubit.dart';
import 'package:lofiii/utils/format_duration.dart';
import 'package:lofiii/utils/menu_helper.dart';

import '../../../../logic/cubit/searchable_list_scroll_controller/download_scroll_controller_state.dart';
import '../../../../logic/cubit/searchable_list_scroll_controller/searchable_list_scroll_controller_cubit.dart';

class MoreMusicButtonWidget extends StatefulWidget {
  const MoreMusicButtonWidget({
    super.key,
    required this.song,
  });

  final LocalMusicModel song;
  @override
  State<MoreMusicButtonWidget> createState() => _MoreMusicButtonWidgetState();
}

class _MoreMusicButtonWidgetState extends State<MoreMusicButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchableListScrollControllerCubit,
        SearchableListScrollControllerState>(
      builder: (context, state) {
        return BlocConsumer<LocalMusicToFavoriteMusicListCubit,
            LocalMusicFavoriteState>(
          listener: (context, favoriteState) {},
          builder: (context, favoriteState) {
            bool isFavorite =
                favoriteState.favoriteList.contains(widget.song.id.toString());

            return GestureDetector(
              onTapDown: (TapDownDetails details) async {
                final offset = details.globalPosition;

                setState(() {
                  MyMenu.showMenuAtPosition(
                      context: context,
                      position: offset,
                      items: [
                        PopupMenuItem(
                          onTap: () {
                            context
                                .read<LocalMusicToFavoriteMusicListCubit>()
                                .favoriteToggle(
                                    musicId: widget.song.id.toString());

                            context
                                .read<FetchFavoriteMusicFromLocalStorageBloc>()
                                .add(
                                    FetchFavoriteMusicFromLocalStorageInitializationEvent());
                          },
                          child: ListTile(
                            title: const Text(
                              "Add to Favorite",
                            ),
                            trailing: isFavorite
                                ? const Icon(FontAwesomeIcons.solidHeart)
                                : const Icon(FontAwesomeIcons.heart),
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
                    const Gap(5),
                    if (widget.song.artwork != null)

                      ///------ Art Work
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(widget.song.artwork!),
                          ),
                        ),
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
