import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lofiii/data/models/lofiii_artist_model.dart';
import 'package:lofiii/data/models/music_model.dart';
import 'package:lofiii/data/repositories/music_repository.dart';

part 'lofiii_music_event.dart';
part 'lofiii_music_state.dart';

class LofiiiMusicBloc extends Bloc<LofiiiMusicEvent, LofiiiMusicState> {
  final MusicRepository _musicRepository = MusicRepository();

  LofiiiMusicBloc() : super(LofiiiMusicInitial()) {
    on<LOFIIIMusicFetchEvent>(_lOFIIIMusicFetchEvent);
  }

  _lOFIIIMusicFetchEvent(
      LOFIIIMusicFetchEvent event, Emitter<LofiiiMusicState> emit) async {
    try {
      emit(LofiiiMusicLoadingState());
      final List<MusicModel> specialMusic =
          await _musicRepository.fetchLOFIIISpecialMusic();

      final List<MusicModel> popularMusic =
          await _musicRepository.fetchLOFIIIPopularMusic();
      final List<MusicModel> topPicksMusic =
          await _musicRepository.fetchLOFIIITopPicksMusic();
      final List<MusicModel> vibesMusic =
          await _musicRepository.fetchLOFIIIVibesMusic();
      final List<LofiiiArtistModel> artistsMusic =
          await _musicRepository.fetchArtists();

      /// Check if any of the fetched data is null or empty
      if (specialMusic.isEmpty ||
          popularMusic.isEmpty ||
          topPicksMusic.isEmpty ||
          vibesMusic.isEmpty ||
          artistsMusic.isEmpty) {
        throw Exception('Failed to fetch music data');
      }

      ///------------- Combined Music List ----------------///
      List<MusicModel> combinedMusicList = <MusicModel>{
        ...specialMusic,
        ...popularMusic,
        ...topPicksMusic,
        ...vibesMusic
      }.toList();

      emit(LofiiiMusicSuccessState(
          specialMusic: specialMusic,
          popularMusic: popularMusic,
          topPicksMusic: topPicksMusic,
          vibesMusic: vibesMusic,
          artistsMusic: artistsMusic,
          combinedMusicList: combinedMusicList));
    } catch (e) {
      emit(LofiiiMusicFailureState(errorMessage: e.toString()));
    }
  }
}
