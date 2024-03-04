part of 'favorite_button_bloc.dart';

@immutable

class FavoriteButtonState extends Equatable {
  const FavoriteButtonState({required this.favoriteList});
  final List<String> favoriteList;


  FavoriteButtonState copyWith({favoriteList}){
    return FavoriteButtonState(favoriteList: favoriteList?? this.favoriteList);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [favoriteList];
}
