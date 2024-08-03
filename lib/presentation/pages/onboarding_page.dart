
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/data/services/app_permissions_service.dart';
import 'package:one_context/one_context.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../logic/bloc/user_profie/user_profile_bloc.dart';
import '../../resources/hive/hive_resources.dart';
import '../../resources/my_assets/my_assets.dart';
import '../widgets/disclaimer_message_widget/disclaimer_message_widget.dart';
import '../widgets/onboarding_skip_button/on_boarding_page_skip_button.dart';
import 'initial/initial_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final TextEditingController usernameController;


  late final DeviceInfoPlugin info;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = DeviceInfoPlugin();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ///!--------  LOFIII  Logo
          Opacity(
            opacity: 0.2,
            child: SvgPicture.asset(
              MyAssets.lofiiiLogoDarkModeSvg,
              height: 1.sh,
            ),
          ),

          ///!------  SKIP Button
          const OnBoardingSkipButton(),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///!----------Profile Image---------///
                SizedBox(
                  height: 0.4.sw,
                  width: 0.4.sw,
                  child: Stack(children: [
                    ///! ----------   Profile Image
                    BlocBuilder<UserProfileBloc, UserProfileState>(
                      builder: (context, state) {
                        if (state.profileImageFilePath.isNotEmpty) {
                          return CircleAvatar(
                            maxRadius: 100,
                            minRadius: 30,
                            backgroundColor: Colors.pink,
                            backgroundImage:
                                FileImage(File(state.profileImageFilePath)),
                          );
                        } else {
                          return const CircleAvatar(
                            maxRadius: 100,
                            minRadius: 30,
                            backgroundColor: Colors.pink,
                          );
                        }
                      },
                    ),

                    ///!------           Profile Pic Change Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              await _profilePicPencilButtonOnTap(context);
                            },
                            icon: const Icon(
                              EvaIcons.edit,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),

                ///!   -----------------   Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      controller: usernameController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            EvaIcons.person,
                            color: Colors.pink,
                          ),
                          hintText: "Enter Your Name",
                          hintStyle: TextStyle(color: Colors.white70)),
                    ),
                  ),
                ),

                Gap(0.01.sh),

                //!---------------------     Get Started Button
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(0.8.sw, 0.06.sh),
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),

                    ///!-----------------   Get Stared On Pressed
                    onPressed: () async {
                      await _getStartedButtonOnTap(context);
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.spMax,
                          fontWeight: FontWeight.bold),
                    )),

                ///! -----------------      Disclaimer   -------------
                const DisclaimerMessageWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///!///////////////////////////////////////////////////////
  ///----------------------  M E T H O D S --------------////
  ///!//////////////////////////////////////////////////////

  ///----- Profile Change Button On Tap
  Future<void> _profilePicPencilButtonOnTap(BuildContext context) async {
    await Permission.mediaLibrary.request();
    await Permission.photos.request();
    context
        .read<UserProfileBloc>()
        .add(UserProfileChangeUserProfilePictureEvent());
  }

  ///-------- Get Started Button On Tap
  Future<void> _getStartedButtonOnTap(BuildContext context) async {



   await AppPermissionService.storagePermission();

    ///-----!   Change User
    context
        .read<UserProfileBloc>()
        .add(UserProfileChangeUsernameEvent(username: usernameController.text));

    ///--!  Navigate to Initial Page
   OneContext().pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  InitialPage(),
        ));

    ///---! Don't Show this screen after restarting app
    MyHiveBoxes.settingBox.put(MyHiveKeys.showOnBoardingScreenHiveKey, false);
  }
}
