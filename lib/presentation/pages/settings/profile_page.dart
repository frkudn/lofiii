import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';
import '../../../logic/bloc/user_profie/user_profile_bloc.dart';
import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../widgets/blur_background_profile_image_widget/blur_background_profile_image_widget.dart';
import '../../widgets/custom_gradient_glass_card/custom_gradient_glass_card_widget.dart';

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
              OneContext().pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
          fit: StackFit.expand,
          children: [

            ///!---------------------------------------------------//
            ///?-----------------  Profile Image    --------- ///
            ///!---------------------------------------------------//
            const _ProfileImageCircleAvatarButton(),

            ///!---------------------------------------------------//
            ///?-----------------  Background Image    --------- ///
            ///!---------------------------------------------------//
            const BlurBackgroundProfileImageWidget(),

            ///!---------------------------------------------------//
            ///?------------   Main Center Box   -------------------////
            ///!---------------------------------------------------//
            Center(
              child: CustomGradientGlassCardWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ///!---------------------------------------------------//
                    ///?------------   Profile Image   -------------------////
                    ///!---------------------------------------------------//
                    const _ProfileImageWidget(),

                    ///!---------------------------------------------------//
                    ///?------------   Profile Name Field   -------------------////
                    ///!---------------------------------------------------//

                    _ProfileNameTextFieldWidget(
                        usernameController: usernameController),

                    ///!---------------------------------------------------//
                    ///?------------   Save Button   -------------------////
                    ///!---------------------------------------------------//
                    _SaveButtonWidget(usernameController: usernameController)
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}

///!---------------------------------------------------//
///?-----------------  Profile Image    --------- ///
///!---------------------------------------------------//

class _ProfileImageCircleAvatarButton extends StatelessWidget {
  const _ProfileImageCircleAvatarButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
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
                    if (state.profileImageFilePath.isNotEmpty) {
                      return CircleAvatar(
                        maxRadius: 100,
                        minRadius: 30,
                        backgroundImage:
                        FileImage(File(state.profileImageFilePath)),
                      );
                    } else {
                      return BlocBuilder<ThemeModeCubit, ThemeModeState>(
                        builder: (context, state) {
                          return CircleAvatar(
                            maxRadius: 100,
                            minRadius: 30,
                            backgroundColor: Color(state.accentColor),
                          );
                        },
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
    );
  }
}

///!---------------------------------------------------//
///?------------   Profile Name Field   -------------------////
///!---------------------------------------------------//

class _ProfileNameTextFieldWidget extends StatelessWidget {
  const _ProfileNameTextFieldWidget({
    required this.usernameController,
  });

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.spMax),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, themeState) {
          return BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, userProfileState) {
              return Column(
                children: [
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Profile Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.spMax,
                            color:
                            themeState.isDarkMode?null:Colors.white70),
                      )),
                  TextField(
                    maxLines: 1,
                    onSubmitted: (value) {
                      context.read<UserProfileBloc>().add(
                          UserProfileChangeUsernameEvent(
                              username: usernameController.text));
                      OneContext().pop();
                    },
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: userProfileState.username,
                      hintStyle: const TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      enabled: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

///!---------------------------------------------------//
///?------------   Profile Image   -------------------////
///!---------------------------------------------------//
class _ProfileImageWidget extends StatelessWidget {
  const _ProfileImageWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.amber,
      height: 0.4.sw,
      width: 0.4.sw,
      child: Stack(children: [
        BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state.profileImageFilePath.isNotEmpty) {
              return SpinPerfect(
                child: CircleAvatar(
                  maxRadius: 100,
                  minRadius: 30,
                  backgroundImage: FileImage(File(state.profileImageFilePath)),
                ),
              );
            } else {
              return BlocBuilder<ThemeModeCubit, ThemeModeState>(
                builder: (context, state) {
                  return SpinPerfect(
                    child: CircleAvatar(
                      maxRadius: 100,
                      minRadius: 30,
                      backgroundColor: Color(state.accentColor),
                    ),
                  );
                },
              );
            }
          },
        ),

        ///!------  Profile Pic Change Button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FadeIn(
              child: CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        context
                            .read<UserProfileBloc>()
                            .add(UserProfileChangeUserProfilePictureEvent());
                      },
                      icon: const Icon(
                        EvaIcons.edit,
                      ))),
            ),
          ),
        )
      ]),
    );
  }
}

///!---------------------------------------------------//
///?------------   Save Button   -------------------////
///!---------------------------------------------------//
class _SaveButtonWidget extends StatelessWidget {
  const _SaveButtonWidget({
    required this.usernameController,
  });

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<UserProfileBloc>().add(
            UserProfileChangeUsernameEvent(username: usernameController.text));
        OneContext().pop();
      },
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.spMax),
            child: BounceInUp(
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 0.5.sw,
                    maxWidth: 0.8.sw,
                    minHeight: 0.05.sh,
                    maxHeight: 0.07.sh,
                  ),
                  decoration: BoxDecoration(
                      color: Color(state.accentColor).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.spMax),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
