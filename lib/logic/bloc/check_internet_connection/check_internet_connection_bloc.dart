import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'; // Import this for BuildContext
import 'package:lofiii/di/dependency_injection.dart';
import 'package:one_context/one_context.dart';

import '../../cubit/youtube_music/youtube_music_cubit.dart';
import '../artists_data/artists_data_bloc.dart';
import '../artists_data/artists_data_event.dart';
import '../lofiii_all_music/lofiii_all_music_bloc.dart';
import '../lofiii_all_music/lofiii_all_music_event.dart';
import '../lofiii_popular_music/lofiii_popular_music_bloc.dart';
import '../lofiii_special_music/lofiii_special_music_bloc.dart';
import '../lofiii_top_picks_music/lofi_top_picks_music_bloc.dart';
import '../lofiii_top_picks_music/lofi_top_picks_music_event.dart';
import '../lofiii_vibes_music/lofiii_vibes_music_bloc.dart';
import '../lofiii_vibes_music/lofiii_vibes_music_event.dart';

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
    on<InternetConnectionRestoredEvent>((event, emit) {
      ///!-----------Refresh LOFIII Special Music --------------///
      OneContext()
          .context!
          .read<LofiiiSpecialMusicBloc>()
          .add(LOFIIISpecialMusicFetchEvent());

      ///!-----------Refresh LOFIII Popular Music --------------///
      OneContext()
          .context!
          .read<LofiiiPopularMusicBloc>()
          .add(LOFIIIPopularMusicFetchEvent());

      ///!-----------Refresh LOFIII TopPicks Music --------------///
      OneContext()
          .context!
          .read<LofiiiTopPicksMusicBloc>()
          .add(LOFIIITopPicksMusicFetchEvent());

      ///!-----------Refresh LOFIII All Music --------------///
      OneContext()
          .context!
          .read<LofiiiAllMusicBloc>()
          .add(LOFIIIAllMusicFetchEvent());

      ///!-----------Refresh Artist Data --------------///
      OneContext()
          .context!
          .read<ArtistsDataBloc>()
          .add(ArtistsDataFetchEvent());
    });

    ///!-----------Refresh LOFIII Vibes Music --------------///
    OneContext()
        .context!
        .read<LofiiiVibesMusicBloc>()
        .add(LofIIIVibesMusicFetchEvent());

    OneContext().context!.read<YoutubeMusicCubit>().fetchMusic();
  }
}
