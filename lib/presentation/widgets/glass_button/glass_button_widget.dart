


import 'dart:ui';

import 'package:flutter/material.dart';


class GlassButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData iconData;

  const GlassButtonWidget({super.key,
    required this.onPressed,
    required this.label,
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(iconData, color: Colors.white,),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
      ),
    );
  }
}

