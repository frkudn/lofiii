// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/models/music_model.dart';
import '../../../data/repositories/music_repository.dart';
import 'lofi_top_picks_music_event.dart';
import 'lofi_top_picks_music_state.dart';


class LofiiiTopPicksMusicBloc extends Bloc<LofiiiTopPicksMusicEvent, LofiiiTopPicksMusicState> {

  final MusicRepository _musicRepository = MusicRepository();

  LofiiiTopPicksMusicBloc() : super(LofiiiTopPicksMusicInitial()) {
    on<LOFIIITopPicksMusicFetchEvent>(_lOFIIISpecialMusicFetchEvent);
  }

  FutureOr<void> _lOFIIISpecialMusicFetchEvent(LOFIIITopPicksMusicFetchEvent event, Emitter<LofiiiTopPicksMusicState> emit) async{
    try{
      emit(LofiiiTopPicksMusicLoadingState());
      final List<MusicModel> list = await _musicRepository.fetchLOFIIITopPicksMusic();
      emit(LofiiiTopPicksMusicSuccessState(musicList: list));




    }catch(e){
      emit(LofiiiTopPicksMusicFailureState(errorMessage: e.toString()));
    }
  }
}
