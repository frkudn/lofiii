import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:meta/meta.dart';

part 'flip_card_state.dart';

class FlipCardCubit extends Cubit<FlipCardCubitState> {
  FlipCardCubit() : super(FlipCardCubitState(flipCardController: FlipCardController()));


  toggleCard()async{
    emit(await state.flipCardController.flipcard());
  }




}
