import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/presentation/pages/settings/privacy_policy.dart';
import 'package:lofiii/presentation/pages/settings/profile_page.dart';
import 'package:lofiii/resources/my_assets/my_assets.dart';
import 'package:lottie/lottie.dart';
import 'package:one_context/one_context.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/theme/colors_palates.dart';
import '../../widgets/license/license_widget.dart';
import '../../widgets/settings_list_tile/settings_list_tile_widget.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.05.sh),
          child: SlideInDown(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///?-------------------   TOP SETTING HEADING  -----------------------------///
                SizedBox(
                  height: 0.1.sh,
                  width: double.infinity,
                  child: Text(
                    " Settings",
                    style: TextStyle(fontSize: 19.sp, letterSpacing: 1),
                  ),
                ),
            
                ///!-------------------Theme SECTION-----------------------------///
                Row(
                  children: [
                    Text(
                      "  APPEARANCE ",
                      style: TextStyle(fontSize: 16.sp, letterSpacing: 1),
                    ),
                    const Icon(EvaIcons.colorPalette)
                  ],
                ),
            
                SizedBox(
                  height: 0.01.sh,
                ),
            
                ///!-------------------Accent Color Switch Tile-----------------------------///
                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                  builder: (context, state) {
                    return ListTile(
                      title: const Text("Accent Color"),
                      trailing: CircleAvatar(
                        radius: 15.spMax,
                        backgroundColor: Color(state.accentColor),
                      ),
                      onTap: _accentColorTileOnTap,
                    );
                  },
                ),
            
                ///!-------------------Dark Mode Switch Tile-----------------------------///
                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                  builder: (context, state) {
                    return SwitchListTile(
                        value: state.isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeModeCubit>().changeThemeMode();
                        },
                        title: const Text("Dark Mode"));
                  },
                ),
            
                ///!-------------------Black Mode Switch Tile-----------------------------///
                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                  builder: (context, state) {
                    return Visibility(
                      visible: state.isDarkMode,
                      child: SwitchListTile(
                          value: state.isBlackMode,
                          onChanged: (value) {
                            context.read<ThemeModeCubit>().changeIntoBlackMode();
                          },
                          title: const Text("Black Mode")),
                    );
                  },
                ),
            
                Gap(0.02.sh),
            
                ///?-------------------GENERAL SECTION-----------------------------///
                Text(
                  "  GENERAL",
                  style: TextStyle(fontSize: 16.sp, letterSpacing: 1.5),
                ),
            
                Gap(0.01.sh),
            
                ///!-------------------Profile-----------------------------///
                SettingsListTileWidget(
                  title: "Profile",
                  iconData: EvaIcons.person,
                  onTap: () {
                    OneContext().push(MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
                  },
                ),
            
                _divider(),
            
                ///!-------------------Equalizer-----------------------------///
                BlocBuilder<ThemeModeCubit, ThemeModeState>(
                  builder: (context, state) {
                    return SettingsListTileWidget(
                      title: "Equalizer",
                      iconData: Icons.equalizer,
                      onTap: equalizerOnTap,
                    );
                  },
                ),
            
                _divider(),
            
                ///!-------------------Feedback-----------------------------///
                SettingsListTileWidget(
                  title: "Feedback",
                  iconData: Icons.feedback,
                  onTap: () async {
                    await _feedBackButtonOnTap();
                  },
                ),
            
                _divider(),
            
                ///!-------------------Privacy Policy-----------------------------///
                SettingsListTileWidget(
                  title: "Privacy Policy",
                  iconData: Icons.policy,
                  onTap: () {
                    OneContext().push(MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ));
                  },
                ),
            
                _divider(),
            
                ///!------------------- Licenses-----------------------------///
                const LicenceWidget(),
            
                _divider(),
            
                ///!-------------------About-----------------------------///
                SettingsListTileWidget(
                    title: "About",
                    iconData: CupertinoIcons.info,
                    onTap: () {
                      OneContext().push(MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ));
                    }),
            
                SizedBox(
                  height: 0.1.sh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider _divider() {
    return const Divider();
  }
  ////////////////////!//////////////////////////////////////////////////
  ///?------------------------    M E T H O D S  --------------------///
  //!/////////////////////////////////////////////////////////////////////

  _accentColorTileOnTap() {
    OneContext.instance.showModalBottomSheet(
      elevation: 1,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      builder: (context) => GridView.builder(
        itemCount: MyColor.colorHexCodesList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (BuildContext context, int index) => _customGridTile(
          colorCode: MyColor.colorHexCodesList[index],
        ),
      ),
    );
  }

  ///!---------------    Custom List of Accent Color
  _customGridTile({
    required colorCode,
  }) {
    return InkWell(
      onTap: () {
       OneContext().context?.read<ThemeModeCubit>().changeAccentColor(colorCode: colorCode);
      },
      child: CircleAvatar(
        backgroundColor: Color(colorCode),
      ),
    );
  }

  ///! -------     Equalizer On Tap
  equalizerOnTap() async {
    OneContext().showDialog(
      builder: (context) => AlertDialog(
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Lottie.asset(MyAssets.lottieWorkInProgressAnimation),
                  Text(
                    "Work in progress, will be in next update!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.spMax),
                  )
                ],
              ),
            )),
      ),
    );
  }

  ///!------------ Feedback On Tap
  Future<void> _feedBackButtonOnTap() async {
    final Email sendEmail = Email(
      body: 'your feed back?',
      subject: 'LOFIII Feedback',
      recipients: ['furqanuddin@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(sendEmail);
  }
}


