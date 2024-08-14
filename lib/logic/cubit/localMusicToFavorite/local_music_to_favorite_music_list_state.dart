part of 'local_music_to_favorite_music_list_cubit.dart';

class LocalMusicFavoriteState extends Equatable {
  const LocalMusicFavoriteState({required this.favoriteList});
  final List favoriteList;

  LocalMusicFavoriteState copyWith({favoriteList}) {
    return LocalMusicFavoriteState(
        favoriteList: favoriteList ?? this.favoriteList);
  }

  @override
  List<Object?> get props => [favoriteList];
}
