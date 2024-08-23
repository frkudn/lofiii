// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lofiii_artist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LofiiiArtistModelAdapter extends TypeAdapter<LofiiiArtistModel> {
  @override
  final int typeId = 3;

  @override
  LofiiiArtistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LofiiiArtistModel(
      name: fields[0] as String,
      img: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LofiiiArtistModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LofiiiArtistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
