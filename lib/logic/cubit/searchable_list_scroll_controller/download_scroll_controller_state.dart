
import 'package:equatable/equatable.dart';


class SearchableListScrollControllerState extends Equatable {

  const SearchableListScrollControllerState({required this.scrollOffset});

  final double scrollOffset;
  // final scrollPosController = locator.get<ScrollController>();
  // final scrollPosController = ScrollController();

  SearchableListScrollControllerState copyWith({scrollOffset}){
    return SearchableListScrollControllerState(scrollOffset: scrollOffset??this.scrollOffset);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [scrollOffset];
}


