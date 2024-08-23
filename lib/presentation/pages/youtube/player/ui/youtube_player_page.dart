

import 'package:flutter/widgets.dart';

class YouTubeMusicPlayerPage extends StatefulWidget {
  const YouTubeMusicPlayerPage({super.key});

  @override
  State<YouTubeMusicPlayerPage> createState() => _YouTubeMusicPlayerPageState();
}

class _YouTubeMusicPlayerPageState extends State<YouTubeMusicPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Player Screen"),
    );
  }
}