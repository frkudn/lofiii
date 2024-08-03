// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'greeting_state.dart';

class GreetingCubit extends Cubit<GreetingState> {
  // Constructor for the GreetingCubit class, initializing it with a default greeting.
  GreetingCubit() : super(const GreetingState(greeting: "Hello!"));

  // Method to update the greeting based on the current time.
  updateGreeting() {
    // Getting the current hour.
    var hour = DateTime.now().hour;

    // Checking the current hour to determine the appropriate greeting.
    if (hour < 12) {
      emit(state.copyWith(greeting: "Good Morning"));
    } else if (hour < 17) {
      emit(state.copyWith(greeting: "Good Afternoon"));
    } else if (hour < 21) {
      emit(state.copyWith(greeting: "Good Evening"));
    } else {
      emit(state.copyWith(greeting: "Good Night"));
    }
  }
}
