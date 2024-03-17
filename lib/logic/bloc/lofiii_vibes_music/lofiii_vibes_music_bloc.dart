

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/music_model.dart';
import '../../../data/repositories/music_repository.dart';
import 'lofiii_vibes_music_event.dart';
import 'lofiii_vibes_music_state.dart';

class LofiiiVibesMusicBloc extends Bloc<LofiiiVibesMusicEvent, LofiiiVibesMusicState> {

  final MusicRepository _musicRepository = MusicRepository();

  LofiiiVibesMusicBloc() : super(LofiiiVibesMusicInitial()) {
    on<LofIIIVibesMusicFetchEvent>(_lOFIIISpecialMusicFetchEvent);
  }

  FutureOr<void> _lOFIIISpecialMusicFetchEvent(LofIIIVibesMusicFetchEvent event, Emitter<LofiiiVibesMusicState> emit) async{
    try{
      emit(LofiiiVibesMusicLoadingState());
      final List<MusicModel> list = await _musicRepository.fetchLOFIIIVibesMusic();
      emit(LofiiiVibesMusicSuccessState(musicList: list));




    }catch(e){
      emit(LofiiiVibesMusicFailureState(errorMessage: e.toString()));
    }
  }
}
