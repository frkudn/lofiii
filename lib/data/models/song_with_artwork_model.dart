import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';

class SongWithArtwork {
  final SongModel song;
  final Uint8List? artwork;

  SongWithArtwork({required this.song, this.artwork});

  // Convenience getters
  String get title => song.title;
  String? get artist => song.artist;
  String? get album => song.album;
  int get id => song.id;
  String get data => song.data;
  String? get uri => song.uri;
  String get displayName => song.displayName;
  String get displayNameWOExt => song.displayNameWOExt;
  int get size => song.size;
  int? get albumId => song.albumId;
  int? get artistId => song.artistId;
  String? get genre => song.genre;
  int? get genreId => song.genreId;
  int? get bookmark => song.bookmark;
  String? get composer => song.composer;
  int? get dateAdded => song.dateAdded;
  int? get dateModified => song.dateModified;
  int? get duration => song.duration;
  int? get track => song.track;
  String get fileExtension => song.fileExtension;

  // Boolean getters
  bool? get isAlarm => song.isAlarm;
  bool? get isAudioBook => song.isAudioBook;
  bool? get isMusic => song.isMusic;
  bool? get isNotification => song.isNotification;
  bool? get isPodcast => song.isPodcast;
  bool? get isRingtone => song.isRingtone;

  // Factory method to create from a map
  factory SongWithArtwork.fromMap(Map<String, dynamic> map) {
    return SongWithArtwork(
      song: map['song'] as SongModel,
      artwork: map['artwork'] as Uint8List?,
    );
  }

  // Method to convert to a map
  Map<String, dynamic> toMap() {
    return {
      'song': song,
      'artwork': artwork,
    };
  }

  @override
  String toString() {
    return 'SongWithArtwork(title: $title, artist: $artist, album: $album, hasArtwork: ${artwork != null})';
  }
}