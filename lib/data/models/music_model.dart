import 'package:hive/hive.dart';

part 'music_model.g.dart';

@HiveType(typeId: 2)
class MusicModel {
  MusicModel({
    required this.id,
    required this.title,
    required this.artists,
    required this.url,
    required this.image,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> artists;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String image;

  // Add fromJson constructor
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] as int,
      title: json['title'] as String,
      artists: List<String>.from(json['artists']),
      url: json['url'] as String,
      image: json['image'] as String,
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artists': artists,
      'url': url,
      'image': image,
    };
  }
}