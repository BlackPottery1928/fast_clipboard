import 'dart:typed_data';

class RecordEvent {
  late String idx;
  late String type;
  late String text;
  late Uint8List image;
  late List<String> files;
  late String hash = '';

  RecordEvent();
}
