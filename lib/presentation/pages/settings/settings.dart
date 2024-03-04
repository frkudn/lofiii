import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/presentation/pages/settings/privacy_policy.dart';
import 'package:lofiii/presentation/pages/settings/profile_page.dart';


import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/theme/colors_palates.dart';
import '../../widgets/settings/settings_list_tile_widget.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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

              ///-------------------Profile-----------------------------///
              SettingsListTileWidget(
                title: "Profile",
                iconData: EvaIcons.person,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                },
              ),

              _divider(),

              ///-------------------Equalizer-----------------------------///
              SettingsListTileWidget(
                title: "Equalizer",
                iconData: Icons.equalizer,
                onTap: equalizerOnTap,
              ),

              _divider(),

              ///-------------------Feedback-----------------------------///
              SettingsListTileWidget(
                title: "Feedback",
                iconData: Icons.feedback,
                onTap: () {},
              ),

              _divider(),

              ///-------------------Privacy Policy-----------------------------///
              SettingsListTileWidget(
                title: "Privacy Policy",
                iconData: Icons.policy,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage(),));
                },
              ),

              _divider(),

              ///-------------------About-----------------------------///
               SettingsListTileWidget(
                  title: "About", iconData: CupertinoIcons.info,onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage(),));
              }),

              SizedBox(
                height: 0.1.sh,
              ),


            ],
          ),
        ),
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey.shade300,
    );
  }

  ///------------------!             M E T H O D S  --------------------///
  _accentColorTileOnTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Select the Color",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
          ),
          _customListTile(
              context: context, colorCode: MyColor.teal, label: "Teal"),
          _customListTile(
              context: context,
              colorCode: MyColor.blueViolet,
              label: "Blue-violet"),
          _customListTile(
              context: context,
              colorCode: MyColor.blazeOrange,
              label: "Blaze Orange"),
          _customListTile(
              context: context,
              colorCode: MyColor.brightMagenta,
              label: "Bright Magenta"),
          _customListTile(
              context: context,
              colorCode: MyColor.cadmiumRed,
              label: "Cadmium Red"),
          _customListTile(
              context: context,
              colorCode: MyColor.goldenPoppy,
              label: "Golden Poppy"),
          _customListTile(
              context: context,
              colorCode: MyColor.parisGreen,
              label: "Paris Green"),
        ],
      ),
    );
  }

  ///!---------------    Custom List of Accent Color
  ListTile _customListTile(
      {required BuildContext context, required colorCode, label}) {
    return ListTile(
      title: Text(
        label ?? "",
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            shadows: [Shadow(color: Colors.black, blurRadius: 1)]),
      ),
      onTap: () {
        context.read<ThemeModeCubit>().changeAccentColor(colorCode: colorCode);
        Navigator.pop(context);
      },
      tileColor: Color(colorCode),
    );
  }
  
  
  ///!       Equalizer On Tap
  equalizerOnTap()async{
    showDialog(
      builder: (context) => 
        AlertDialog(
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("This feature is currently not available", style: TextStyle(fontSize: 16.sp),),
        ),
      ), context: context,
    );
  }
}
