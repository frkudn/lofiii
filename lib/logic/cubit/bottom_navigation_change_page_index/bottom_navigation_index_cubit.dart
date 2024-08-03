// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bottom_navigation_index_state.dart';

class BottomNavigationIndexCubit extends Cubit<BottomNavigationIndexState> {
  BottomNavigationIndexCubit() : super(const BottomNavigationIndexState(pageIndex: 0));



  changePageIndex({required int index}){
    emit(state.copyWith(pageIndex: index));
  }
}
