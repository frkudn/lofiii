import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


import '../../../logic/bloc/user_profie/user_profile_bloc.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/theme/colors_palates.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController usernameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///----------Profile Image---------///
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return Container(
                height: 0.3.sh,
                decoration: BoxDecoration(
                    color: Color(state.accentColor),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(13),
                      bottomRight: Radius.circular(13),
                    )),
                child: Center(
                  child: SizedBox(
                    // color: Colors.amber,
                    height: 0.4.sw,
                    width: 0.4.sw,
                    child: Stack(children: [
                      ///! ----------   Profile Image
                      BlocBuilder<UserProfileBloc, UserProfileState>(
                        builder: (context, state) {
                          if (state.profileImageFilePath != null) {
                            return CircleAvatar(
                              maxRadius: 100,
                              minRadius: 30,
                              backgroundImage:
                                  FileImage(File(state.profileImageFilePath)),
                            );
                          } else {
                            return const CircleAvatar(
                              maxRadius: 100,
                              minRadius: 30,
                              backgroundColor: Color(MyColor.teal),
                            );
                          }
                        },
                      ),

                      ///!------  Profile Pic Change Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    context.read<UserProfileBloc>().add(
                                        UserProfileChangeUserProfilePictureEvent());
                                  },
                                  icon: const Icon(
                                    EvaIcons.edit,
                                  ))),
                        ),
                      )
                    ]),
                  ),
                ),
              );
            },
          ),

          ///!------------   User Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "Profile",
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                return TextField(
                  maxLines: 1,
                  onSubmitted: (value) {
                    context.read<UserProfileBloc>().add(
                        UserProfileChangeUsernameEvent(
                            username: usernameController.text));
                    Navigator.pop(context);
                  },
                  controller: usernameController,
                  decoration:
                      InputDecoration(hintText: state.username ?? "Your name"),
                );
              },
            ),
          ),

          Gap(0.03.sh),



          //!---------------------     S A V E   B U T T O N
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<UserProfileBloc>().add(
                      UserProfileChangeUsernameEvent(
                          username: usernameController.text));

                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: 0.7.sw,
                    height: 0.05.sh,
                    decoration: BoxDecoration(
                        color: Color(state.accentColor),
                        borderRadius: BorderRadius.circular(30)),
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMax,
                          color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
