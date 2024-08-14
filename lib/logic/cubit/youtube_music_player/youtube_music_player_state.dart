part of 'youtube_music_player_cubit.dart';

@immutable
sealed class YoutubeMusicPlayerState extends Equatable {}

final class YoutubeMusicPlayerInitialState extends YoutubeMusicPlayerState {
  @override
  List<Object?> get props => [];
}

final class YoutubeMusicPlayerLoadingState extends YoutubeMusicPlayerState {
  @override
  List<Object?> get props => [];
}

final class YoutubeMusicPlayerSuccessState extends YoutubeMusicPlayerState {
  YoutubeMusicPlayerSuccessState({
    required this.controller,
    required this.showPlayerButtons,
    required this.showVideoPositionOnHDragging,
    required this.screenLock,


  });
  final PodPlayerController controller;

 final bool showVideoPositionOnHDragging;
  final bool showPlayerButtons;
  final bool screenLock;



  YoutubeMusicPlayerSuccessState copyWith(
      {showVideoPositionOnHDragging, showPlayerButtons, rotateScreen, screenLock}) {
    return YoutubeMusicPlayerSuccessState(
      controller: controller,
      screenLock: screenLock??this.screenLock,
      showPlayerButtons: showPlayerButtons ?? this.showPlayerButtons,
      showVideoPositionOnHDragging:
          showVideoPositionOnHDragging ?? this.showVideoPositionOnHDragging,

    );
  }

  @override
  List<Object?> get props => [
        controller,
        showVideoPositionOnHDragging, showPlayerButtons,
        screenLock,
        showPlayerButtons
      ];
}

final class YoutubeMusicPlayerFailureState extends YoutubeMusicPlayerState {
  @override
  List<Object?> get props => [];
}
