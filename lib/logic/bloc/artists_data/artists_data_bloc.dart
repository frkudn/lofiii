
import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../data/models/artist_model.dart';
import '../../../data/repositories/music_repository.dart';
import 'artists_data_event.dart';
import 'artists_data_state.dart';

class ArtistsDataBloc extends Bloc<ArtistsDataEvent, ArtistsDataState> {
  final MusicRepository _musicRepository = MusicRepository();

  ArtistsDataBloc() : super(ArtistsDataInitialState()) {
    on<ArtistsDataFetchEvent>(_artistsDataFetchEvent);
  }

  FutureOr<void> _artistsDataFetchEvent(
      ArtistsDataFetchEvent event, Emitter<ArtistsDataState> emit) async {
    try {
      emit(ArtistsDataLoadingState());
      final List<ArtistModel> list = await _musicRepository.fetchArtists();
      emit(ArtistsDataSuccessState(artistList: list));
    } catch (e) {
      emit(ArtistsDataFailureState(errorMessage: e.toString()));
    }
  }
}
