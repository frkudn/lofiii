import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'show_mini_player_state.dart';

class ShowMiniPlayerCubit extends Cubit<ShowMiniPlayerState> {
  ShowMiniPlayerCubit() : super(ShowMiniPlayerState(showMiniPlayer: false));

  showMiniPlayer(){
    emit(state.copyWith(showMiniPlayer: true));
  }
}
