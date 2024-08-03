


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/link.dart';

class SocialMediaIconButton extends StatelessWidget {
  const SocialMediaIconButton(
      {super.key, required this.url, required this.icon, this.iconSize});
  final String url;
  final iconSize;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(url),
      target: LinkTarget.blank,
      builder: (context, followLink) => IconButton(
        onPressed: () {
          followLink!(); // Call followLink function to navigate
        },
        icon: Icon(
          icon,
          size: iconSize ?? 40.spMax,
        ),
      ),
    );
  }
}
