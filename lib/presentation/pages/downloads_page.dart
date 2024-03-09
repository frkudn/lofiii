import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:lofiii/resources/my_assets/my_assets.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<FileSystemEntity> musicsList = [];

  @override
  void initState() {
    super.initState();
    // getSongs();
  }

  // Future<void> getSongs() async {
  //
  //   await MediaDownload().requestPermission();
  //     // Get downloads directory
  //     final Directory? downloadsDir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  //
  //     if (downloadsDir != null) {
  //       final List<FileSystemEntity> _files = downloadsDir.listSync(recursive: true, followLinks: false);
  //       musicsList = _files.where((entity) => entity.path.endsWith(".mp3") || entity.path.endsWith(".m4a")).toList();
  //
  //       // Debugging: Print out the path and check if it's correct
  //       log("Downloaded files path: ${downloadsDir.path}");
  //       musicsList.forEach((file) {
  //         log("Found file: ${file.path}");
  //       });
  //
  //       setState(() {}); // Triggering rebuild after fetching files
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Downloads"),
    //   ),
    //   body: musicsList.isEmpty
    //       ? const Center(
    //     child: Text("No Music found!"),
    //   )
    //       : ListView.builder(
    //     itemCount: musicsList.length,
    //     itemBuilder: (context, index) => ListTile(
    //       title: Text(path.basename(musicsList[index].path)),
    //       subtitle: Text(musicsList[index].path),
    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(MyAssets.lottieWorkInProgressAnimation),
              const Text(
                  "Download feature is only added in player for testing... but this section isn't completed yet!"),
            ],
          ),
        ),
      ),
    );
  }
}



