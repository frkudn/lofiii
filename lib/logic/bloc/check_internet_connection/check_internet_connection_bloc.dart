import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // Import this for BuildContext

import '../artists_data/artists_data_bloc.dart';
import '../artists_data/artists_data_event.dart';
import '../lofiii_all_music/lofiii_all_music_bloc.dart';
import '../lofiii_all_music/lofiii_all_music_event.dart';
import '../lofiii_popular_music/lofiii_popular_music_bloc.dart';
import '../lofiii_special_music/lofiii_special_music_bloc.dart';
import '../lofiii_top_picks_music/lofi_top_picks_music_bloc.dart';
import '../lofiii_top_picks_music/lofi_top_picks_music_event.dart';

part 'check_internet_connection_event.dart';
part 'check_internet_connection_state.dart';

class CheckInternetConnectionBloc extends Bloc<CheckInternetConnectionEvent, CheckInternetConnectionState> {

  final Connectivity connectivity;
  final BuildContext context; // Add BuildContext here

  // Constructor to initialize the bloc with Connectivity instance
  CheckInternetConnectionBloc({required this.connectivity, required this.context})
      : super(CheckInternetConnectionInitial()) {

    // Listen for changes in connectivity
    connectivity.onConnectivityChanged.listen((connectivityResult) {
      // If connectivity is neither mobile nor wifi, dispatch NoInternetConnectionEvent
      if (connectivityResult != ConnectivityResult.mobile &&
          connectivityResult != ConnectivityResult.wifi) {
        add(NoInternetConnectionEvent());
      }
      else{
        add(InternetConnectionRestoredEvent());

      }
    });

    // Handle NoInternetConnectionEvent by emitting NoInternetConnectionState
    on<NoInternetConnectionEvent>((event, emit) {
      emit(NoInternetConnectionState());
    });


    ///-------------Auto add Events on Internet Restored Event ---------------///
    on<InternetConnectionRestoredEvent>((event, emit) {
      ///-----------Refresh LOFIII Special Music --------------///
    context.read<LofiiiSpecialMusicBloc>().add(LOFIIISpecialMusicFetchEvent());

    ///-----------Refresh LOFIII Popular Music --------------///
    context.read<LofiiiPopularMusicBloc>().add(LOFIIIPopularMusicFetchEvent());

    ///-----------Refresh LOFIII TopPicks Music --------------///
    context.read<LofiiiTopPicksMusicBloc>().add(LOFIIITopPicksMusicFetchEvent());

    ///-----------Refresh LOFIII All Music --------------///
    context.read<LofiiiAllMusicBloc>().add(LOFIIIAllMusicFetchEvent());

    ///-----------Refresh Artist Data --------------///
    context.read<ArtistsDataBloc>().add(ArtistsDataFetchEvent());
    });


  }
}
