

class MusicModel {
  final int id;
  final String title;
  final List<String> artists;
  final String url;
  final String image;

  MusicModel({
    required this.id,
    required this.title,
    required this.artists,
    required this.url,
    required this.image,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'] as int,
      title: json['title'] as String,
      artists: List<String>.from(json['artists'] as List),
      url: json['url'] as String,
      image: json['image'] as String,
    );
  }

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
