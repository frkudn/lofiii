import 'package:json_annotation/json_annotation.dart';

part 'music_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MusicModel {
  const MusicModel({
    required this.id,
    required this.title,
    required this.artists,
    required this.url,
    required this.image,
  });

  /// The unique identifier of the music.
  final int id;

  /// The title of the music.
  final String title;

  /// The artist/s associated with the music.
  final List<String> artists;

  /// The public url of the music.
  final String url;

  /// The photo or cover of the music.
  final String image;

  /// Converts a `Map<String, dynamic>` into a [MusicModel] instance.
  static MusicModel fromJson(Map<String, dynamic> json) =>
      _$MusicModelFromJson(json);

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}
