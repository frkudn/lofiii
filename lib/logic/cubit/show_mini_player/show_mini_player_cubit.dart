// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'show_mini_player_state.dart';

class ShowMiniPlayerCubit extends Cubit<ShowMiniPlayerState> {
  ShowMiniPlayerCubit() : super(const ShowMiniPlayerState(showMiniPlayer: false));

  showMiniPlayer(){
    emit(state.copyWith(showMiniPlayer: true));
  }

  hideMiniPlayer(){
    emit(state.copyWith(showMiniPlayer: false));
  }
}
