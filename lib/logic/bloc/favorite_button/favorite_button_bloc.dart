// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../resources/hive/hive_resources.dart';

part 'favorite_button_event.dart';
part 'favorite_button_state.dart';

class FavoriteButtonBloc
    extends Bloc<FavoriteButtonEvent, FavoriteButtonState> {

  // Initialize the bloc with the initial state
  FavoriteButtonBloc() : super( FavoriteButtonState(favoriteList: MyHive.favoriteMusicList)) {
    // Listen for FavoriteButtonToggleEvent and call _favoriteToggle method
    on<FavoriteButtonToggleEvent>(_favoriteToggle);
  }
  //! Method to handle toggling favorite state
  FutureOr<void> _favoriteToggle(FavoriteButtonToggleEvent event,
      Emitter<FavoriteButtonState> emit) {
    //! Get the current favorite list from Hive
    List<String> favoriteList = MyHive.favoriteMusicList;

    //! Check if the title is already in the favorite list
    bool isFavorite = favoriteList.contains(event.title);

    //! Toggle the favorite status
    if (isFavorite) {
      //! If already favorite, remove it from the list
      favoriteList.remove(event.title);
      //! Update the favorite list in Hive
      MyHiveBoxes.libraryBox.put(MyHiveKeys.favoriteHiveKey, favoriteList);
      //! Emit the new state with the updated favorite list
      emit(state.copyWith(favoriteList: favoriteList));

    } else {
      //! If not favorite, add it to the list
      favoriteList.add(event.title);
      //! Update the favorite list in Hive
      MyHiveBoxes.libraryBox.put(MyHiveKeys.favoriteHiveKey, favoriteList);
      //! Emit the new state with the updated favorite list
      emit(state.copyWith(favoriteList: favoriteList));

    }

    //! Emit the new state with the updated favorite list
    emit(state.copyWith(favoriteList: favoriteList));

    //! Print the updated favorite list (for debugging purposes)
    log(favoriteList.toString());
  }




}
