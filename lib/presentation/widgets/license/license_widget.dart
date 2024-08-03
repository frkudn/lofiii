

import 'package:flutter/material.dart';
import 'package:lofiii/data/services/app_services.dart';
import 'package:one_context/one_context.dart';

import '../../../resources/consts/consts.dart';
import '../settings_list_tile/settings_list_tile_widget.dart';

class LicenceWidget extends StatelessWidget {
  const LicenceWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return SettingsListTileWidget(
      title: "License",
      iconData: Icons.description,
      onTap: () {
        OneContext().showDialog(
          builder: (context) => AlertDialog(
            title: const Text('Licenses'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MIT License:\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mitLicenses,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16),
                  ),
                  // Add more licenses as needed
                ],
              ),
            ),
            actions: [



              TextButton(
                onPressed: () {
                  OneContext().showDialog(builder: (p0) => const AboutDialog(
                    applicationVersion: AppServices.appFullVersion,

                  ));
                },
                child: const Text('More Licenses'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}