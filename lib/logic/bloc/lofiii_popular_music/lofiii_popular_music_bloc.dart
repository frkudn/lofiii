
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/music_model.dart';
import '../../../data/repositories/music_repository.dart';

part 'lofiii_popular_music_event.dart';
part 'lofiii_popular_music_state.dart';

class LofiiiPopularMusicBloc extends Bloc<LofiiiPopularMusicEvent, LofiiiPopularMusicState> {

  final MusicRepository _musicRepository = MusicRepository();

  LofiiiPopularMusicBloc() : super(LofiiiPopularMusicInitial()) {
    on<LOFIIIPopularMusicFetchEvent>(_lOFIIISpecialMusicFetchEvent);
  }

  FutureOr<void> _lOFIIISpecialMusicFetchEvent(LOFIIIPopularMusicFetchEvent event, Emitter<LofiiiPopularMusicState> emit) async{
    try{
      emit(LofiiiPopularMusicLoadingState());
      final List<MusicModel> list = await _musicRepository.fetchLOFIIIPopularMusic();
      emit(LofiiiPopularMusicSuccessState(musicList: list));




    }catch(e){
      emit(LofiiiPopularMusicFailureState(errorMessage: e.toString()));
    }
  }
}
