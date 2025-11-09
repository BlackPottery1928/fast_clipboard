import 'dart:typed_data';

class RecordEvent {
  final String idx;
  final String type;
  final Uint8List text;

  RecordEvent({required this.idx, required this.type, required this.text});
}
