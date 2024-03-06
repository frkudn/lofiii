import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/menu_helper.dart';

class PlayerScreenMoreButtonWidget extends StatelessWidget {
  const PlayerScreenMoreButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (TapDownDetails details) {
          MenuHelper.showMenuAtPosition(
              context: context,

              ///!---------       Position     ------------/////
              position: details.globalPosition,

              ///!------------------    Items     -------------////
              items: [
                PopupMenuItem(
                  child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Downloading feature is currently not available"),
                            ),
                          ),
                        );
                      },
                      leading: const Icon(FontAwesomeIcons.download),
                      title: const Text("Download")),
                ),
                PopupMenuItem(
                    child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "Lyrics feature is currently not available"),
                        ),
                      ),
                    );
                  },
                  leading: const Icon(Icons.lyrics),
                  title: const Text("Lyrics"),
                )),
              ]);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_vert_rounded,
            color: CupertinoColors.white,
          ),
        ));
  }
}
