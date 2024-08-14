part of 'favorite_button_bloc.dart';

@immutable
abstract class FavoriteButtonEvent extends Equatable {}

class FavoriteButtonToggleEvent extends FavoriteButtonEvent {
  FavoriteButtonToggleEvent({required this.title});
  final String title;

  @override
  List<Object?> get props => [title];
}
