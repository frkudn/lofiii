import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/logic/cubit/now_playing_offline_music_data_to_player/now_playing_offline_music_data_to_player_cubit.dart';
import 'package:lofiii/presentation/pages/player/offline_player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<FetchMusicFromLocalStorageBloc>()
        .add(FetchMusicFromLocalStorageInitializationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body:

           // !/------------------  Music List -----////
          BlocConsumer<FetchMusicFromLocalStorageBloc,
              FetchMusicFromLocalStorageState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is FetchMusicFromLocalStorageSuccessState) {
            return FutureBuilder(
              future: state.musicsList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {

                  final musicListLength = snapshot.data!.length;


                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: musicListLength,
                    itemBuilder: (context, index) {

                      ///---------  Music Data ---------------///
                      final musicTitle = snapshot.data![index].title;
                      final artistName = snapshot.data![index].artist.toString();
                      final currentMusicUri = snapshot.data![index].uri;
                      final musicListLength = snapshot.data!.length;
                      final snapShotMusicList = snapshot.data!;
                      ////--------------------------------------///
                      return ListTile(
                        onTap: () {
                          _listTileOnTap(index: index,musicList: state.musicsList,currentMusic: currentMusicUri,musicTitle: musicTitle,artistsName: artistName, musicListLength: musicListLength, snapshotMusicList: snapShotMusicList);
                        },

                        ///-------  Music Icon
                        leading: const Icon(
                          FontAwesomeIcons.music,
                          // color: Colors.white,
                        ),

                        ///!---------  Music Title
                        title: Text(
                          musicTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),

                        ///!--------  Artists
                        subtitle: Text(
                          artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                  );
                } else{
                 return const Center(
                    child: Text("No Music Found!"),
                  );
                }
              }
            );
          }  else if (state is FetchMusicFromLocalStorageFailureState) {
            return Center(
              child: Text(state.failureMessage),
            );
          } else {
            return const Center(
              child: Text("No Music Found!"),
            );
          }
        },
      ),





    );
  }

  ///-------------------------------------------------------///
  ///!----------------------  Methods -------------------///
  ///-----------------------------------------------------///
  _listTileOnTap({required musicList,required index, currentMusic,required musicTitle,required artistsName,required musicListLength,required snapshotMusicList}) {
    ///!-----Play Music------
    context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(url: currentMusic));

    context.read<ShowMiniPlayerCubit>().showMiniPlayer();
    context.read<ShowMiniPlayerCubit>().offlineMusicIsPlaying();

    // ///!-----Show Offline Player Screen ----///
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => OfflinePlayerPage(),
    );

    ///!---- Send Data to Offline Player
    context.read<NowPlayingOfflineMusicDataToPlayerCubit>().sendDataToPlayer(
        musicIndex: index, futureMusicList: musicList,
      musicTitle: musicTitle,
      musicArtist: artistsName,
      musicListLength: musicListLength,
      snapshotMusicList: snapshotMusicList
    );
  }
}
