import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lofiii/resources/my_assets/my_assets.dart';
import 'package:lottie/lottie.dart';

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
            Lottie.asset(MyAssets.lottieWorkInProgressAnimation),
            Text("Work in progress...")
          ],
        ),
      ),
    );
  }
}
