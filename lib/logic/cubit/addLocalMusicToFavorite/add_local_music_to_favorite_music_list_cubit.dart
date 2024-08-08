import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../resources/hive/hive_resources.dart';

part 'add_local_music_to_favorite_music_list_state.dart';

class LocalMusicToFavoriteMusicListCubit
    extends Cubit<LocalMusicToFavoriteMusicListState> {
  LocalMusicToFavoriteMusicListCubit()
      : super(AddLocalMusicToFavoriteMusicListInitial());

  ///----------Add Music To Favorite
  Future<void> addMusicToFavorite(String musicTitle) async {
    try {
      // Get current favorite music list from Hive
      List<String> favoriteMusicList = await MyHiveBoxes.libraryBox
              .get(MyHiveKeys.localFavoriteMusicListHiveKey) ??
          [];

      // Check if music title is already in the list
      if (!favoriteMusicList.contains(musicTitle)) {
        // Add new song title to the list
        favoriteMusicList.add(musicTitle);

        // Update the favorite music list in Hive
        await MyHiveBoxes.libraryBox.put(
          MyHiveKeys.localFavoriteMusicListHiveKey,
          favoriteMusicList,
        );

        // Emit success state
        emit(LocalMusicToFavoriteMusicListIsSuccessfullyAddedState());

        emit(CheckLocalMusicInFavoriteMusicListState(available: true));
      } else{
        emit(LocalMusicToFavoriteMusicListIsAlreadyExistsState());
         emit(CheckLocalMusicInFavoriteMusicListState(available: true));
      }
    } catch (e) {
      emit(LocalMusicToFavoriteMusicListFailureState(
          errorMessage: e.toString()));
    }
  }

  /// Remove Music from Favorites
  Future<void> removeMusicToFavorite(String musicTitle) async {
    try {
      // Get current favorite music list from Hive
      List<String> favoriteMusicList = await MyHiveBoxes.libraryBox
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
      emit(LocalMusicToFavoriteMusicListIsSuccessfullyRemovedState());
       emit(CheckLocalMusicInFavoriteMusicListState(available: false));
    } catch (error) {
      // Emit failure state with error message
      emit(
        LocalMusicToFavoriteMusicListFailureState(
          errorMessage: error.toString(),
        ),
      );
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
