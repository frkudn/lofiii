part of 'lofiii_music_search_system_cubit.dart';

class LofiiiMusicSearchSystemState extends Equatable {

  const LofiiiMusicSearchSystemState({required this.filteredlist});
  final List<MusicModel> filteredlist;

  LofiiiMusicSearchSystemState copyWith({filteredlist}) {
    return LofiiiMusicSearchSystemState(
        filteredlist: filteredlist ?? this.filteredlist);
  }

  @override
  List<Object?> get props => [filteredlist];
}
