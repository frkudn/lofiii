import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

@HiveType(typeId: 0)
class LocalMusicModel {
   LocalMusicModel({required this.song, this.artwork});
  @HiveField(0)
  final SongModel song;

  @HiveField(1)
  final Uint8List? artwork;

 

  // Convenience getters
  @HiveField(2)
  String get title => song.title;

  @HiveField(3)
  String? get artist => song.artist;

  @HiveField(4)
  String? get album => song.album;

  @HiveField(5)
  int get id => song.id;

  @HiveField(6)
  String get data => song.data;

  @HiveField(7)
  String? get uri => song.uri;

  @HiveField(8)
  String get displayName => song.displayName;

  @HiveField(9)
  String get displayNameWOExt => song.displayNameWOExt;

  @HiveField(10)
  int get size => song.size;

  @HiveField(11)
  int? get albumId => song.albumId;

  @HiveField(12)
  int? get artistId => song.artistId;

  @HiveField(13)
  String? get genre => song.genre;

  @HiveField(14)
  int? get genreId => song.genreId;

  @HiveField(15)
  int? get bookmark => song.bookmark;

  @HiveField(16)
  String? get composer => song.composer;

  @HiveField(17)
  int? get dateAdded => song.dateAdded;

  @HiveField(18)
  int? get dateModified => song.dateModified;

  @HiveField(19)
  int? get duration => song.duration;

  @HiveField(20)
  int? get track => song.track;

  @HiveField(21)
  String get fileExtension => song.fileExtension;

  // Boolean getters
  @HiveField(22)
  bool? get isAlarm => song.isAlarm;

  @HiveField(23)
  bool? get isAudioBook => song.isAudioBook;

  @HiveField(24)
  bool? get isMusic => song.isMusic;

  @HiveField(25)
  bool? get isNotification => song.isNotification;

  @HiveField(26)
  bool? get isPodcast => song.isPodcast;

  @HiveField(27)
  bool? get isRingtone => song.isRingtone;

  @override
  String toString() {
    return 'LocalMusicModel(title: $title, artist: $artist, album: $album, hasArtwork: ${artwork != null})';
  }
}