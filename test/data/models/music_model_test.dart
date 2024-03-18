import 'package:flutter_test/flutter_test.dart';
import 'package:lofiii/data/data.dart';

void main() {
  const validArtists = ['Chill', 'Hip-Hop', 'Fruits', 'Minnie'];
  const validImage =
      'https://miro.medium.com/v2/resize:fit:1358/0*FjF2hZ8cJQN9aBxk.jpg';
  const validTitle = 'rain in my heart';
  const validUrl = 'https://www.youtube.com/watch?v=Yqvkml-Obgw';
  group('MusicModel', () {
    MusicModel createSubject({
      int id = 1,
      List<String> artists = validArtists,
      String image = validImage,
      String title = validTitle,
      String url = validUrl,
    }) {
      return MusicModel(
        id: id,
        artists: artists,
        image: image,
        title: title,
        url: url,
      );
    }

    group('fromJson', () {
      test('parses json correctly', () {
        expect(
          () => MusicModel.fromJson(const <String, dynamic>{
            'id': 1,
            'title': validTitle,
            'artists': validArtists,
            'url': validUrl,
            'image': validImage,
          }),
          returnsNormally,
        );
      });
    });
    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'id': 1,
            'title': validTitle,
            'artists': validArtists,
            'url': validUrl,
            'image': validImage,
          }),
        );
      });
    });
  });
}
