import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/music_model.dart';

part 'lofiii_music_search_system_state.dart';

class LofiiiMusicSearchSystemCubit extends Cubit<LofiiiMusicSearchSystemState> {
  LofiiiMusicSearchSystemCubit()
      : super(const LofiiiMusicSearchSystemState(filteredlist: []));

  searchNow(
      {required String val, required List<MusicModel> combinedMusicList}) {
    emit(LofiiiMusicSearchSystemState(
      filteredlist: combinedMusicList
          .where((MusicModel element) =>
              element.title
                  .toString()
                  .toLowerCase()
                  .contains(val.toLowerCase().toString()) ||
              element.artists.first
                  .toString()
                  .toLowerCase()
                  .contains(val.toLowerCase().toString()) ||
              element.artists.last
                  .toString()
                  .toLowerCase()
                  .contains(val.toLowerCase().toString()))
          .toList(),
    ));
  }
}
