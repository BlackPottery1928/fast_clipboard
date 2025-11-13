import 'dart:typed_data';

class RecordDefinition {
  late String index;
  late String type = 'text';
  late String text;
  late Uint8List image;
  late List<String> files;
  
  late int length = 0;
  late bool selected = false;
  late String hash = '';
  late DateTime updated;

  RecordDefinition();
}

class NotDefinition extends RecordDefinition {
  NotDefinition();
}
