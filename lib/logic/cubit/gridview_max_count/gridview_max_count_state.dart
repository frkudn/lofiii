part of 'gridview_max_count_cubit.dart';

@immutable
class GridviewMaxCountState {
  const GridviewMaxCountState({required this.maxCount});
  final int maxCount;

  GridviewMaxCountState copyWith({maxCount}){
    return GridviewMaxCountState(maxCount: maxCount??this.maxCount);
  }
}

