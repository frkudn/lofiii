part of 'show_mini_player_cubit.dart';

@immutable
 class ShowMiniPlayerState {

  ShowMiniPlayerState({required this.showMiniPlayer});
  final bool showMiniPlayer;


  ShowMiniPlayerState copyWith({showMiniPlayer}){
    return ShowMiniPlayerState(showMiniPlayer: showMiniPlayer?? this.showMiniPlayer);
  }
}


