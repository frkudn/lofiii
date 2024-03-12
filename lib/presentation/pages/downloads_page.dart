import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lofiii/logic/bloc/fetch_music_from_local_storage/fetch_music_from_local_storage_bloc.dart';
import 'package:lofiii/logic/bloc/player/music_player_bloc.dart';
import 'package:lofiii/presentation/pages/player/offline_player_page.dart';
import 'package:lofiii/presentation/pages/player/player_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';
import '../../logic/cubit/show_mini_player/show_mini_player_cubit.dart';
import '../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../utils/format_duration.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FetchMusicFromLocalStorageBloc>().add(FetchMusicFromLocalStorageInitializationEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ///-----  Music List -----////
          BlocConsumer<FetchMusicFromLocalStorageBloc, FetchMusicFromLocalStorageState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {

              if(state is FetchMusicFromLocalStorageSuccessState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.musicsList.length,
                    itemBuilder: (context, index) {
                      return _buildMusicTile(
                       index: index,
                        musicList: state.musicsList
                      );
                    },
                  ),
                );
              } else if(state is FetchMusicFromLocalStorageLoadingState){
               return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if(state is FetchMusicFromLocalStorageFailureState){
                return Center(
                  child: Text(state.failureMessage),
                );
              } else{
                return const Center(
                  child: Text("No Music Found!"),
                );
              }
            },
          ),
        ],
      ),
    );
  }


  ///-----Music List -----///
  Widget _buildMusicTile({required List<FileSystemEntity> musicList,required int index}) {



    final musicTitle = File(musicList[index].path)
        .uri
        .pathSegments
        .last
        .replaceAll('.m4a', "")
        .replaceAll('.mp3', '');
    return ListTile(

      onTap: () {
        ///!-----Play Music------
        context
            .read<MusicPlayerBloc>()
            .add(MusicPlayerPlayLocalEvent(musicPath: musicList[index].path));


        ///!-----Hide Mini Player-----///
        context.read<ShowMiniPlayerCubit>().hideMiniPlayer();


        // ///!-----Show Offline Player Screen ----///
        showModalBottomSheet(
          showDragHandle: true,
          isScrollControlled: true,
          context: context,
          builder: (context) =>
              OfflinePlayerPage(
                index: index,
               localMusicList: musicList,),
        );



      },
      leading: const CircleAvatar(
          child: Icon(FontAwesomeIcons.music, color: Colors.white,)),
      title: Text(
        musicTitle,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}



