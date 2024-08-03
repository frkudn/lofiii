part of 'download_music_bloc.dart';

@immutable
abstract class DownloadMusicEvent extends Equatable {}



class DownloadNowEvent extends DownloadMusicEvent{
  DownloadNowEvent({required this.url, required this.fileName,required this.context});
  final String url;
  final String fileName;
  final BuildContext context;

  @override
  List<Object?> get props => [url, fileName, context];

}

class MusicIsSuccessfullyDownloadedEvent extends DownloadMusicEvent{
  MusicIsSuccessfullyDownloadedEvent({required this.fileName});
  final String fileName;

  @override
  // TODO: implement props
  List<Object?> get props => [fileName];
}
