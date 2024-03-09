part of 'download_music_bloc.dart';

@immutable
abstract class DownloadMusicEvent extends Equatable {}



class DownloadNowEvent extends DownloadMusicEvent{
  DownloadNowEvent({required this.url, required this.fileName});
  final String url;
  final String fileName;


  @override
  // TODO: implement props
  List<Object?> get props => [url, fileName];

}

class MusicIsSuccessfullyDownloadedEvent extends DownloadMusicEvent{
  MusicIsSuccessfullyDownloadedEvent({required this.fileName});
  final String fileName;

  @override
  // TODO: implement props
  List<Object?> get props => [fileName];
}
