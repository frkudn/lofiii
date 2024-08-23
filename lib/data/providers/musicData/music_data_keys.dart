import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class MusicDataKeys {
  final String lofiiiUrl = dotenv.env['LOFIIIMUSICAPIKEY']!;
}
