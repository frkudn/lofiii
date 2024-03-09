import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:meta/meta.dart';

part 'flip_card_state.dart';

class FlipCardCubit extends Cubit<FlipCardCubitState> {
  FlipCardController flipCardController;
  FlipCardCubit({required this.flipCardController})
      : super(FlipCardCubitState(flipCardController: flipCardController));

  toggleCard() async => emit(await state.flipCardController.flipcard());
}
