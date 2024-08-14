import 'package:flutter/material.dart';

class GlassButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData iconData;

  const GlassButtonWidget(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
      ),
    );
  }
}
