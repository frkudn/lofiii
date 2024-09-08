part of 'favorite_button_bloc.dart';

@immutable
class OnlineMusicFavoriteButtonState extends Equatable {
  const OnlineMusicFavoriteButtonState({required this.favoriteList});
  final List favoriteList;

  OnlineMusicFavoriteButtonState copyWith({favoriteList}) {
    return OnlineMusicFavoriteButtonState(
        favoriteList: favoriteList ?? this.favoriteList);
  }

  @override
  List<Object?> get props => [favoriteList];
}
