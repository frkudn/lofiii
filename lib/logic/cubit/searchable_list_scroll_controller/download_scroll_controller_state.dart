import 'package:equatable/equatable.dart';

class SearchableListScrollControllerState extends Equatable {
  const SearchableListScrollControllerState({required this.scrollOffset});

  final double scrollOffset;

  SearchableListScrollControllerState copyWith({scrollOffset}) {
    return SearchableListScrollControllerState(
        scrollOffset: scrollOffset ?? this.scrollOffset);
  }

  @override
  List<Object?> get props => [scrollOffset];
}
