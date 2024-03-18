// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) => MusicModel(
      id: json['id'] as int,
      title: json['title'] as String,
      artists:
          (json['artists'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artists': instance.artists,
      'url': instance.url,
      'image': instance.image,
    };
