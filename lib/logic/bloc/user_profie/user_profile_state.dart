part of 'user_profile_bloc.dart';

@immutable
class UserProfileState extends Equatable {
  const UserProfileState({required this.username, required this.profileImageFilePath});

  final username;
  final profileImageFilePath;

  UserProfileState copyWith({username, profileImageFilePath}){
    return UserProfileState(username: username??this.username, profileImageFilePath: profileImageFilePath??this.profileImageFilePath);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [username, profileImageFilePath];
}



