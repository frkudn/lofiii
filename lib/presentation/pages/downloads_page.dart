import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lofiii/resources/my_assets/my_assets.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../logic/bloc/download/download_music_bloc.dart';
import '../../logic/cubit/send_current_playing_music_data_to_player_screen/send_music_data_to_player_cubit.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: Center(
        child: Column(
          children: [
            // Lottie.asset(MyAssets.lottieWorkInProgressAnimation),
            // const Text("Work in progress...")




            BlocBuilder<DownloadMusicBloc, DownloadMusicState>(
              builder: (context, state) {
                if(state is DownloadMusicLoadingState){
                  return Text("Downloading is Started");
                } else if(state is DownloadMusicProgressState){
                  return Text("Downloading Progress : ${state.progress}");
                }

                else if(state is DownloadMusicSuccessState){
                  return Text("Music is Downloaded");
                }
                else{
                  return Text("something went wrong");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
