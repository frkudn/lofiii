part of 'show_mini_player_cubit.dart';

@immutable
 class ShowMiniPlayerState extends Equatable{

  const ShowMiniPlayerState({required this.showMiniPlayer, required this.isOnlineMusic,required this.isYouTubeMusic});
  final bool showMiniPlayer;
  final bool isOnlineMusic;
  final bool isYouTubeMusic;


  ShowMiniPlayerState copyWith({showMiniPlayer, isOnlineMusic, isYouTubeMusic}){
    return ShowMiniPlayerState(showMiniPlayer: showMiniPlayer?? this.showMiniPlayer, isOnlineMusic: isOnlineMusic?? this.isOnlineMusic,isYouTubeMusic: isYouTubeMusic??this.isYouTubeMusic);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [showMiniPlayer, isOnlineMusic,isYouTubeMusic];
}


