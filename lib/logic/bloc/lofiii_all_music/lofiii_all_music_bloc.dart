
import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../data/models/music_model.dart';
import '../../../data/repositories/music_repository.dart';
import 'lofiii_all_music_event.dart';
import 'lofiii_all_music_state.dart';


class LofiiiAllMusicBloc extends Bloc<LofiiiAllMusicEvent, LofiiiAllMusicState> {

  final MusicRepository _musicRepository = MusicRepository();

  LofiiiAllMusicBloc() : super(LofiiiAllMusicInitial()) {
    on<LOFIIIAllMusicFetchEvent>(_lOFIIISpecialMusicFetchEvent);
  }

  FutureOr<void> _lOFIIISpecialMusicFetchEvent(LOFIIIAllMusicFetchEvent event, Emitter<LofiiiAllMusicState> emit) async{
    try{
      emit(LofiiiAllMusicLoadingState());
      final List<MusicModel> specialList = await _musicRepository.fetchLOFIIISpecialMusic();
      final List<MusicModel> popularList = await _musicRepository.fetchLOFIIIPopularMusic();
      final List<MusicModel> topPicksList = await _musicRepository.fetchLOFIIITopPicksMusic();
      final List<MusicModel> vibesList = await _musicRepository.fetchLOFIIIVibesMusic();

      List<MusicModel> combinedList = [];
      combinedList = [...specialList, ...popularList, ...topPicksList, ...vibesList].toSet().toList();


      emit(LofiiiAllMusicSuccessState(musicList: combinedList));




    }catch(e){
      emit(LofiiiAllMusicFailureState(errorMessage: e.toString()));
    }
  }
}
