part of 'flip_card_cubit.dart';

@immutable
 class FlipCardCubitState extends Equatable{
  FlipCardCubitState({required this.flipCardController});
  final FlipCardController flipCardController;



  @override
  // TODO: implement props
  List<Object?> get props => [flipCardController];
  
}


