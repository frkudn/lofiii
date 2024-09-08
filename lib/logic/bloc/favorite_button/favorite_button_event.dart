part of 'favorite_button_bloc.dart';

@immutable
abstract class OnlineMusicFavoriteButtonEvent extends Equatable {}

class FavoriteButtonToggleEvent extends OnlineMusicFavoriteButtonEvent {
  FavoriteButtonToggleEvent({required this.title});
  final String title;

  @override
  List<Object?> get props => [title];
}
