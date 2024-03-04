part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent extends Equatable{}


class UserProfileChangeUsernameEvent extends UserProfileEvent{
  UserProfileChangeUsernameEvent({required this.username});
  final String username;

  @override
  // TODO: implement props
  List<Object?> get props => [username];
}
class UserProfileChangeUserProfilePictureEvent extends UserProfileEvent{
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
