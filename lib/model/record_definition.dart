import 'dart:typed_data';

class RecordDefinition {
  late String idx;
  late Uint8List value;
  late int length = 0;
  late bool selected = false;
  late String hash = '';
  late DateTime updated;
  late String type = 'text';

  RecordDefinition();
}

class NotDefinition extends RecordDefinition {
  NotDefinition();
}
