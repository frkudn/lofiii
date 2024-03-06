// ignore_for_file: prefer_collection_literals

class ArtistModel {
  String name;
  String img;

  ArtistModel({
    required this.name,
    required this.img,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['img'] = img;
    return data;
  }
}
