import 'package:json_annotation/json_annotation.dart';

part 'artist_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ArtistModel {
  const ArtistModel({
    required this.name,
    required this.img,
  });

  /// The name of the artist.
  final String name;

  /// The image display of the artist.
  final String img;

  /// Converts a `Map<String, dynamic>` into a [ArtistModel] instance.
  static ArtistModel fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);
}
