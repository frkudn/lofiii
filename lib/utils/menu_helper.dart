

import 'package:flutter/material.dart';


class MenuHelper {
  static Future<T?> showMenuAtPosition<T>({
    required BuildContext context,
    required Offset position,
    required List<PopupMenuEntry<T>> items,
  }) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showMenu<T>(
      context: context,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      color: Theme.of(context).colorScheme.background,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          position,
          Offset(position.dx + 1, position.dy + 1),
        ),
        overlay.localToGlobal(Offset.zero) & overlay.size,
      ),
      items: items,
    );
  }
}