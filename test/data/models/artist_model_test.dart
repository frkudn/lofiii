import 'package:flutter_test/flutter_test.dart';
import 'package:lofiii/data/data.dart';

void main() {
  const validName = 'Chill';
  const validPhoto =
      'https://i.scdn.co/image/ab67616d00001e020ef8bd19cf75a12f6f4416f7';
  group('ArtistModel', () {
    ArtistModel createSubject({
      String name = validName,
      String img = validPhoto,
    }) {
      return ArtistModel(name: name, img: img);
    }

    group('fromJson', () {
      test('parses json correctly', () {
        expect(
          () => ArtistModel.fromJson(const <String, dynamic>{
            'name': validName,
            'img': validPhoto,
          }),
          returnsNormally,
        );
      });
    });
    group('toJson', () {
      test('converts model to json correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'name': validName,
            'img': validPhoto,
          }),
        );
      });
    });
  });
}
