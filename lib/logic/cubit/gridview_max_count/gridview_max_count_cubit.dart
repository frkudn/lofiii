// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'gridview_max_count_state.dart';

class GridViewMaxCountCubit extends Cubit<GridviewMaxCountState> {
  GridViewMaxCountCubit() : super(const GridviewMaxCountState(maxCount: 2));

  changeMaxCount() {
    switch (state.maxCount) {
      case 2:
        emit(state.copyWith(maxCount: 3));
      case 3:
        emit(state.copyWith(maxCount: 1));
      case 1:
        emit(state.copyWith(maxCount: 2));
      default:
        emit(state.copyWith(maxCount: 2));
    }
  }
}
