// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lofiii/exports.dart';
import 'package:rxdart/rxdart.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  // final BuildContext context;

  final audioPlayer = locator.get<AudioPlayer>();

  //! Constructor for the MusicPlayerBloc class, initializing it with AudioPlayer instance.
  MusicPlayerBloc() : super(MusicPlayerLoadingState()) {
    on<MusicPlayerInitializeEvent>(_musicPlayerInitializeEvent);
    on<MusicPlayerTogglePlayPauseEvent>(_musicPlayerTogglePlayPauseEvent);
    on<MusicPlayerSeekEvent>(_musicPlayerSeekEvent);
    on<MusicPlayerStopEvent>(_musicPlayerStopEvent);
    on<MusicPlayerRepeatEvent>(_musicPlayerRepeatEvent);
    on<MusicPlayerShuffleEvent>(_musicPlayerShuffleEvent);
    on<MusicPlayerVolumeSetEvent>(_musicPlayerVolumeSetEvent);
    on<MusicPlayerForwardEvent>(_musicPlayerForwardEvent);
    on<MusicPlayerBackwardEvent>(_musicPlayerBackwardEvent);
    on<MusicPlayerDisposeEvent>(_musicPlayerDisposeEvent);
    on<MusicPlayerOfflineNextMusicEvent>(_musicPlayerOfflineNextMusicEvent);
    on<MusicPlayerOnlineNextMusicEvent>(_musicPlayerOnlineNextMusicEvent);

    on<MusicPlayerOfflinePreviousMusicEvent>(
        _musicPlayerOfflinePreviousMusicEvent);

    on<MusicPlayerOnlinePreviousMusicEvent>(
        _musicPlayerOnlinePreviousMusicEvent);
  }

  //! Method to handle MusicPlayerInitializeEvent and Play Music.
  FutureOr<void> _musicPlayerInitializeEvent(
      MusicPlayerInitializeEvent event, Emitter<MusicPlayerState> emit) async {
    try {
      emit(MusicPlayerLoadingState());

      ///------------ If Music Is Online ------------------////
      if (event.isOnlineMusic) {
        final MediaItem onlineMediaItem = MediaItem(
          artist: event.artist,
          playable: true,
          id: event.musicId.toString(),
          album: event.musicAlbum,
          title: event.musicTitle,
          artUri: Uri.parse(event.onlineMusicThumbnail.toString()),
        );

        final audioSource = ProgressiveAudioSource(
          Uri.parse(event.url.toString()),
          tag: onlineMediaItem,
        );

        audioPlayer.setAudioSource(audioSource);
      }

      ///------------ If Music is Offline ------------------///
      else {
        final MediaItem offlineMediaItem = MediaItem(
          artist: event.artist,
          playable: true,
          duration: audioPlayer.duration,
          displayTitle: event.musicTitle,
          id: event.musicId.toString(),
          album: event.musicAlbum,
          title: event.musicTitle,
          artUri: Uri.dataFromBytes(event.offlineMusicThumbnail!),
        );

        final audioSource = ProgressiveAudioSource(
          Uri.parse(event.url.toString()),
          tag: offlineMediaItem,
        );
        audioPlayer.setAudioSource(audioSource);
      }

      audioPlayer.play();

      //! Combine the position and duration and Buffered streams
      final combinedStream = Rx.combineLatest3(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        audioPlayer.bufferedPositionStream,
        (position, duration, buffered) => [position, duration, buffered],
      ).publish().autoConnect();

      emit(MusicPlayerSuccessState(
        positionStream: audioPlayer.positionStream,
        durationStream: audioPlayer.durationStream,
        playingStream: audioPlayer.playingStream,
        audioPlayer: audioPlayer,
        combinedStreamPositionAndDurationAndBufferedList: combinedStream,
      ));
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerTogglePlayPauseEvent.
  FutureOr<void> _musicPlayerTogglePlayPauseEvent(
      MusicPlayerTogglePlayPauseEvent event, Emitter<MusicPlayerState> emit) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  // Method to handle MusicPlayerSeekEvent.
  FutureOr<void> _musicPlayerSeekEvent(
      MusicPlayerSeekEvent event, Emitter<MusicPlayerState> emit) {
    try {
      audioPlayer.seek(Duration(seconds: event.position));
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerStopEvent.
  FutureOr<void> _musicPlayerStopEvent(
      MusicPlayerStopEvent event, Emitter<MusicPlayerState> emit) {
    try {
      audioPlayer.stop();
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerRepeatEvent.
  FutureOr<void> _musicPlayerRepeatEvent(
      MusicPlayerRepeatEvent event, Emitter<MusicPlayerState> emit) {
    try {
      switch (audioPlayer.loopMode) {
        case LoopMode.off:
          audioPlayer.setLoopMode(LoopMode.all);
          break;
        case LoopMode.all:
          audioPlayer.setLoopMode(LoopMode.one);
          break;
        case LoopMode.one:
          audioPlayer.setLoopMode(LoopMode.off);
          break;
        default:
          audioPlayer.setLoopMode(LoopMode.all);
      }
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  // Method to handle MusicPlayerShuffleEvent.
  FutureOr<void> _musicPlayerShuffleEvent(
      MusicPlayerShuffleEvent event, Emitter<MusicPlayerState> emit) {
    if (audioPlayer.shuffleModeEnabled == false) {
      audioPlayer.setShuffleModeEnabled(true);
    } else {
      audioPlayer.setShuffleModeEnabled(false);
    }
  }

  FutureOr<void> _musicPlayerVolumeSetEvent(
      MusicPlayerVolumeSetEvent event, Emitter<MusicPlayerState> emit) {



  }

  FutureOr<void> _musicPlayerForwardEvent(
      MusicPlayerForwardEvent event, Emitter<MusicPlayerState> emit) {
    try {
      if (audioPlayer.duration != null) {
        if (audioPlayer.position.inSeconds <
            audioPlayer.duration!.inSeconds - 5) {
          audioPlayer
              .seek(Duration(seconds: audioPlayer.position.inSeconds + 5));
        }
      } else {
        audioPlayer.seek(Duration(seconds: audioPlayer.position.inSeconds + 5));
      }
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _musicPlayerBackwardEvent(
      MusicPlayerBackwardEvent event, Emitter<MusicPlayerState> emit) {
    try {
      if (audioPlayer.position.inSeconds > 5) {
        audioPlayer.seek(Duration(seconds: audioPlayer.position.inSeconds - 5));
      }
    } catch (e) {
      emit(MusicPlayerErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _musicPlayerDisposeEvent(
      MusicPlayerDisposeEvent event, Emitter<MusicPlayerState> emit) async {
    await audioPlayer.dispose();
  }

  FutureOr<void> _musicPlayerOfflineNextMusicEvent(
      MusicPlayerOfflineNextMusicEvent event, Emitter<MusicPlayerState> emit) {
    final NowPlayingMusicDataToPlayerState state = event.nowPlayingState;
    final BuildContext context = event.context;
    int index = state.musicIndex;
    if (index < state.musicListLength) {
      index++;
      final music = state.musicList[index];

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.uri.toString(),
          isOnlineMusic: false,
          musicAlbum: music.album ?? "Unknown",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: null,
          offlineMusicThumbnail: music.artwork));

      ///---- Also Change Music Title and Artist on Next Button Clicked
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            musicList: state.musicList,
            musicThumbnail: state.musicList[index].artwork,
            musicTitle: state.musicList[index].title,
            musicArtist: state.musicList[index].artist,
            uri: state.musicList[index].uri,
            musicId: state.musicList[index].id,
            musicListLength: state.musicList.length,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);

      audioPlayer.seekToNext();
    }
  }

  FutureOr<void> _musicPlayerOfflinePreviousMusicEvent(
      MusicPlayerOfflinePreviousMusicEvent event,
      Emitter<MusicPlayerState> emit) {
    final NowPlayingMusicDataToPlayerState state = event.nowPlayingState;
    final BuildContext context = event.context;

    int index = state.musicIndex;
    if (index > 0) {
      index--;
      final music = state.musicList[index];

      ///!-----Change Music------
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.uri.toString(),
          isOnlineMusic: false,
          musicAlbum: music.album ?? "Unknown",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: null,
          offlineMusicThumbnail: music.artwork));

      ///---- Also Change Music Title and Artist on Back Button Clicked
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
            musicIndex: index,
            musicList: state.musicList,
            musicThumbnail: state.musicList[index].artwork,
            musicTitle: state.musicList[index].title,
            musicArtist: state.musicList[index].artist,
            uri: state.musicList[index].uri,
            musicListLength: state.musicList.length,
            musicId: state.musicList[index].id,
          );

      ///!-------  Change Selected Tile Index
      context.read<ThemeModeCubit>().changeSelectedTileIndex(index: index);

      audioPlayer.seekToPrevious();
    }
  }

  FutureOr<void> _musicPlayerOnlineNextMusicEvent(
      MusicPlayerOnlineNextMusicEvent event, Emitter<MusicPlayerState> emit) {
    final NowPlayingMusicDataToPlayerState state = event.nowPlayingState;
    final BuildContext context = event.context;

    int index = state.musicIndex;
    if (index < state.musicList.length) {
      index++;
      final MusicModel music = state.musicList[index];
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.url,
          isOnlineMusic: true,
          musicAlbum: "LOFIII",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: music.image,
          offlineMusicThumbnail: null));
      // context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
      //     musicIndex: index, fullMusicList: state.fullMusicList);
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: state.musicList,
          musicThumbnail: music.image,
          musicTitle: music.title,
          uri: music.url,
          musicId: music.id,
          musicArtist: music.artists,
          musicListLength: state.musicList.length);
    }
  }

  FutureOr<void> _musicPlayerOnlinePreviousMusicEvent(
      MusicPlayerOnlinePreviousMusicEvent event,
      Emitter<MusicPlayerState> emit) {
    final NowPlayingMusicDataToPlayerState state = event.nowPlayingState;
    final BuildContext context = event.context;

    int index = state.musicIndex;
    if (index > 0) {
      index--;
      index++;
      final MusicModel music = state.musicList[index];
      context.read<MusicPlayerBloc>().add(MusicPlayerInitializeEvent(
          url: music.url,
          isOnlineMusic: true,
          musicAlbum: "LOFIII",
          musicId: music.id,
          musicTitle: music.title,
          onlineMusicThumbnail: music.image,
          offlineMusicThumbnail: null));
      // context.read<CurrentlyPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
      //     musicIndex: index, fullMusicList: state.fullMusicList);
      context.read<NowPlayingMusicDataToPlayerCubit>().sendDataToPlayer(
          musicIndex: index,
          musicList: state.musicList,
          musicThumbnail: music.image,
          musicTitle: music.title,
          uri: music.url,
          musicId: music.id,
          musicArtist: music.artists,
          musicListLength: state.musicList.length);
    }
  }
}
