
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/music_model.dart';

part 'search_system_state.dart';

class SearchSystemCubit extends Cubit<SearchSystemState> {
  SearchSystemCubit() : super(const SearchSystemState(filteredlist: []));

  addSearchList({required List<MusicModel> allMusicList}) {


    emit(state.copyWith(filteredlist: allMusicList));
  }

  searchNow({required String val}) {

    emit(state.copyWith(
      filteredlist: state.filteredlist
          .where((MusicModel element) =>
              element.title
                  .toString()
                  .toLowerCase()
                  .contains(val.toLowerCase().toString()) ||
              element.artists.first
                  .toString()
                  .toLowerCase()
                  .contains(val.toLowerCase().toString()))
          .toList(),
    ));
  }
}
