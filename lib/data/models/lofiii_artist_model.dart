import 'package:hive/hive.dart';

part 'lofiii_artist_model.g.dart';

@HiveType(typeId: 3)
class LofiiiArtistModel {
  const LofiiiArtistModel({
    required this.name,
    required this.img,
  });

  /// The name of the artist.
  @HiveField(0)
  final String name;

  /// The image display of the artist.
  @HiveField(1)
  final String img;

  // Add fromJson constructor
  factory LofiiiArtistModel.fromJson(Map<String, dynamic> json) {
    return LofiiiArtistModel(
      name: json['name'] as String,
      img: json['img'] as String,
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }
}