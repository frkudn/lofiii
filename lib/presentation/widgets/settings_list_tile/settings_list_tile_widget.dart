

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SettingsListTileWidget extends StatelessWidget {
  const SettingsListTileWidget({
    super.key,
    required this.iconData,
    required this.title,
    this.onTap,
  });

  final IconData iconData;
  final String title;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(iconData),
          title: Text(title),
          onTap: onTap,
        ),
      ],
    );
  }
}