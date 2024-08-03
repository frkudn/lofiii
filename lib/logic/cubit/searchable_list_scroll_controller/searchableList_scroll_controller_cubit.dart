import 'package:bloc/bloc.dart';
import 'package:lofiii/logic/cubit/searchable_list_scroll_controller/download_scroll_controller_state.dart';




class SearchableListScrollControllerCubit extends Cubit<SearchableListScrollControllerState> {

  SearchableListScrollControllerCubit() : super(SearchableListScrollControllerState(scrollOffset: 0));




  updateScrollOffset({scrollOffset}){
    emit(state.copyWith(scrollOffset: scrollOffset));
  }
}
