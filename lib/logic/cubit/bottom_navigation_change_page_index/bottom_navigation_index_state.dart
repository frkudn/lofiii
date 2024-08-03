part of 'bottom_navigation_index_cubit.dart';

@immutable
 class BottomNavigationIndexState extends Equatable{
  const BottomNavigationIndexState({required this.pageIndex});

  final int pageIndex;

  BottomNavigationIndexState copyWith({pageIndex}){
    return BottomNavigationIndexState(pageIndex: pageIndex?? this.pageIndex);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [pageIndex];
}


