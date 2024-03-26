part of 'youtube_music_player_cubit.dart';

@immutable
sealed class YoutubeMusicPlayerState extends Equatable {}

final class YoutubeMusicPlayerInitialState extends YoutubeMusicPlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class YoutubeMusicPlayerLoadingState extends YoutubeMusicPlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class YoutubeMusicPlayerSuccessState extends YoutubeMusicPlayerState {
  YoutubeMusicPlayerSuccessState({
    required this.controller,
    required this.showPlayerButtons,
    required this.showVideoPositionOnHDragging,
    required this.screenLock,
    required this.videoPosition,
    required this.videoTotalDuration,
    required this.videoIsBuffering,
    required this.videoState,

  });
  final PodPlayerController controller;

  bool showVideoPositionOnHDragging;
  bool showPlayerButtons;
  bool screenLock;

  final videoPosition;
  final videoTotalDuration ;
  final videoState ;
  final videoIsBuffering ;

  YoutubeMusicPlayerSuccessState copyWith(
      {showVideoPositionOnHDragging, showPlayerButtons, rotateScreen, screenLock}) {
    return YoutubeMusicPlayerSuccessState(
      controller: controller,
      screenLock: screenLock??this.screenLock,
      showPlayerButtons: showPlayerButtons ?? this.showPlayerButtons,
      showVideoPositionOnHDragging:
          showVideoPositionOnHDragging ?? this.showVideoPositionOnHDragging,
      videoIsBuffering: videoIsBuffering,
      videoState: videoState,
      videoPosition: videoPosition,
      videoTotalDuration: videoTotalDuration
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        controller,
        showVideoPositionOnHDragging, showPlayerButtons,
        screenLock,

      ];
}

final class YoutubeMusicPlayerFailureState extends YoutubeMusicPlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
