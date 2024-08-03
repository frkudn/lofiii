part of 'flip_card_cubit.dart';

@immutable
 class FlipCardCubitState extends Equatable{
   FlipCardCubitState();

  final  flipCardController = locator.get<FlipCardController>();

  @override
  // TODO: implement props
  List<Object?> get props => [flipCardController];
  
}


