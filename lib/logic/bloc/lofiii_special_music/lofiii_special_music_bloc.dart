

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/music_model.dart';
import '../../../data/repositories/music_repository.dart';

part 'lofiii_special_music_event.dart';
part 'lofiii_special_music_state.dart';

class LofiiiSpecialMusicBloc extends Bloc<LofiiiSpecialMusicEvent, LofiiiSpecialMusicState> {

  final MusicRepository _musicRepository = MusicRepository();

  LofiiiSpecialMusicBloc() : super(LofiiiSpecialMusicInitial()) {
    on<LOFIIISpecialMusicFetchEvent>(_lOFIIISpecialMusicFetchEvent);
  }

  FutureOr<void> _lOFIIISpecialMusicFetchEvent(LOFIIISpecialMusicFetchEvent event, Emitter<LofiiiSpecialMusicState> emit) async{
    try{
      emit(LofiiiSpecialMusicLoadingState());
      final List<MusicModel> list = await _musicRepository.fetchLOFIIISpecialMusic();
      emit(LofiiiSpecialMusicSuccessState(musicList: list));




    }catch(e){
      emit(LofiiiSpecialMusicFailureState(errorMessage: e.toString()));
    }
  }
}
