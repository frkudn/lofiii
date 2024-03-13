part of 'show_mini_player_cubit.dart';

@immutable
 class ShowMiniPlayerState extends Equatable{

  const ShowMiniPlayerState({required this.showMiniPlayer, required this.isOnlineMusic});
  final bool showMiniPlayer;
  final bool isOnlineMusic;


  ShowMiniPlayerState copyWith({showMiniPlayer, isOnlineMusic}){
    return ShowMiniPlayerState(showMiniPlayer: showMiniPlayer?? this.showMiniPlayer, isOnlineMusic: isOnlineMusic?? this.isOnlineMusic);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [showMiniPlayer, isOnlineMusic];
}


