// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofiii/di/dependency_injection.dart';
import 'package:meta/meta.dart';

import '../../../resources/hive/hive_resources.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ImagePicker picker = locator.get<ImagePicker>();
  UserProfileBloc()
      : super(UserProfileState(
            username: MyHiveBoxes.settingBox.get(MyHiveKeys.profileUsernameHiveKey) ??
                "Guest",
            profileImageFilePath:
            MyHiveBoxes.settingBox.get(MyHiveKeys.profilePicHiveKey) ?? "")) {
    on<UserProfileChangeUserProfilePictureEvent>(
        _userProfileChangeUserProfilePictureEvent);
    on<UserProfileChangeUsernameEvent>(_userProfileChangeUsernameEvent);
  }


  ///!----------  Profile Pic Change
  FutureOr<void> _userProfileChangeUserProfilePictureEvent(
      UserProfileChangeUserProfilePictureEvent event,
      Emitter<UserProfileState> emit) async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      emit(state.copyWith(profileImageFilePath: image.path.toString()));
      MyHiveBoxes.settingBox.put(MyHiveKeys.profilePicHiveKey, image.path.toString());
    }
  }


  ///!----------    Username Change
  FutureOr<void> _userProfileChangeUsernameEvent(UserProfileChangeUsernameEvent event, Emitter<UserProfileState> emit)async {
    if(event.username.isNotEmpty){
      emit(state.copyWith(username: event.username));
      await MyHiveBoxes.settingBox.put(MyHiveKeys.profileUsernameHiveKey, event.username.toString());
    }

  }
}
