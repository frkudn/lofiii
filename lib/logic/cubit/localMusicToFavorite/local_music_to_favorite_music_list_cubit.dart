import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../resources/hive/hive_resources.dart';

part 'local_music_to_favorite_music_list_state.dart';

class LocalMusicToFavoriteMusicListCubit
    extends Cubit<LocalMusicFavoriteState> {
  LocalMusicToFavoriteMusicListCubit()
      : super(LocalMusicFavoriteState(
          favoriteList: MyHiveBoxes.libraryBox
              .get(MyHiveKeys.localFavoriteMusicListHiveKey, defaultValue: []),
        ));

  /// Remove Music from Favorites
  Future<void> removeMusicToFavorite(String musicTitle) async {
    // Get current favorite music list from Hive
    List favoriteMusicList = await MyHiveBoxes.libraryBox
            .get(MyHiveKeys.localFavoriteMusicListHiveKey) ??
        [];

    // Remove music title from the list
    favoriteMusicList.removeWhere((title) => title == musicTitle);

    // Update the favorite music list in Hive
    await MyHiveBoxes.libraryBox.put(
      MyHiveKeys.localFavoriteMusicListHiveKey,
      favoriteMusicList,
    );

    // Emit success state
    emit(LocalMusicFavoriteState(favoriteList: favoriteMusicList));
  }

  //! Method to handle toggling favorite state
  FutureOr<void> favoriteToggle(musicTitle) {
    //! Get the current favorite list from Hive
    List<String> favoriteList =
        MyHiveBoxes.libraryBox.get(MyHiveKeys.localFavoriteMusicListHiveKey) ??
            [];

    //! Check if the title is already in the favorite list
    bool isFavorite = favoriteList.contains(musicTitle);

    //! Toggle the favorite status
    if (isFavorite) {
      //! If already favorite, remove it from the list
      favoriteList.remove(musicTitle);
      //! Update the favorite list in Hive
      MyHiveBoxes.libraryBox
          .put(MyHiveKeys.localFavoriteMusicListHiveKey, favoriteList);
      //! Emit the new state with the updated favorite list
      emit(LocalMusicFavoriteState(favoriteList: favoriteList));
    } else {
      //! If not favorite, add it to the list
      favoriteList.add(musicTitle);
      //! Update the favorite list in Hive
      MyHiveBoxes.libraryBox
          .put(MyHiveKeys.localFavoriteMusicListHiveKey, favoriteList);
      //! Emit the new state with the updated favorite list
      emit(LocalMusicFavoriteState(favoriteList: favoriteList));
    }
  }

//  /// Check if music is already in Favorites
// Future<void> checkMusicToFavorite(String musicTitle) async {
//   try {
//     // Get current favorite music set from Hive
//     final favoriteMusicSet = MyHiveBoxes.libraryBox
//         .get(MyHiveKeys.localFavoriteMusicListHiveKey) ?? [];

//     // Check if music title is in the favorite set
//      bool isFavorite = favoriteMusicSet.contains(musicTitle);

//     // Emit state with the result
//     emit(CheckLocalMusicInFavoriteMusicListState(available: isFavorite));

//   } catch (error) {
//     // Emit failure state with error message
//     emit(
//       LocalMusicToFavoriteMusicListFailureState(
//         errorMessage: error.toString(),
//       ),
//     );
//   }
// }
}
