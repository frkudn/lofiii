part of 'search_system_cubit.dart';

@immutable


class SearchSystemState extends Equatable {
  const SearchSystemState({required this.filteredlist});
  final List<MusicModel> filteredlist;


  SearchSystemState copyWith({filteredlist}){
    return SearchSystemState(filteredlist: filteredlist?? this.filteredlist);
  }

  @override
  List<Object?> get props => [filteredlist];
}
