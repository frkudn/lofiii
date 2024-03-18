
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../di/dependency_injection.dart';

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


