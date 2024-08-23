import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // Import this for BuildContext
import 'package:lofiii/di/dependency_injection.dart';
import 'package:lofiii/logic/bloc/fetch_lofiii_music_from_internet/lofiii_music_bloc.dart';
import 'package:one_context/one_context.dart';

part 'check_internet_connection_event.dart';
part 'check_internet_connection_state.dart';

class CheckInternetConnectionBloc
    extends Bloc<CheckInternetConnectionEvent, CheckInternetConnectionState> {
  final connectivity = locator.get<Connectivity>();

  // Constructor to initialize the bloc with Connectivity instance
  CheckInternetConnectionBloc() : super(CheckInternetConnectionInitial()) {
    // Listen for changes in connectivity
    connectivity.onConnectivityChanged.listen((connectivityResult) {
      // If connectivity is neither mobile nor wifi, dispatch NoInternetConnectionEvent
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        add(NoInternetConnectionEvent());
      } else {
        add(InternetConnectionRestoredEvent());
      }
    });

    // Handle NoInternetConnectionEvent by emitting NoInternetConnectionState
    on<NoInternetConnectionEvent>((event, emit) {
      emit(NoInternetConnectionState());
    });

    ///!-------------Auto add Events on Internet Restored Event ---------------///
    on<InternetConnectionRestoredEvent>(
      (event, emit) {
        ///!-----------Refresh LOFIII Music --------------///
        OneContext()
            .context!
            .read<LofiiiMusicBloc>()
            .add(LOFIIIMusicFetchEvent());
      },
    );
  }
}
