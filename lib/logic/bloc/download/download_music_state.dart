part of 'download_music_bloc.dart';

@immutable
abstract class DownloadMusicState extends Equatable {}

class DownloadMusicInitialState extends DownloadMusicState {
  @override
  List<Object?> get props => [];
}

class DownloadMusicLoadingState extends DownloadMusicState {
  DownloadMusicLoadingState({required this.fileName});
  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

class DownloadMusicProgressState extends DownloadMusicState {
  DownloadMusicProgressState({required this.progress});
  final double progress;

  @override
  List<Object?> get props => [progress];
}

class DownloadMusicSuccessState extends DownloadMusicState {
  DownloadMusicSuccessState({required this.fileName});
  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

class DownloadMusicFailureState extends DownloadMusicState {
  DownloadMusicFailureState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object?> get props => [errorMessage];
}
