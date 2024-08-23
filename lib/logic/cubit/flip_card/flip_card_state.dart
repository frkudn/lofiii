part of 'flip_card_cubit.dart';

 class FlipCardCubitState extends Equatable{
   FlipCardCubitState();

  final  flipCardController = locator.get<FlipCardController>();

  @override
  List<Object?> get props => [flipCardController];
  
}


