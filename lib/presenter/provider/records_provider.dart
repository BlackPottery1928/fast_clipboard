import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/model/record_definition.dart';
import 'package:fast_clipboard/presenter/database/database_handler.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:flutter/foundation.dart';
import 'package:hashlib/hashlib.dart' as hashlib;

class RecordsProvider with ChangeNotifier {
  final List<RecordDefinition> linked = [];

  List<RecordDefinition> get records => linked;

  void addRecord(RecordEvent event) {
    String textHashValue = hashlib.md5.convert(event.text.codeUnits).toString();
    RecordDefinition? exist = linked.firstWhere(
      (element) =>
          element.hash == textHashValue &&
          element.length == event.text.length &&
          element.value == event.text,
      orElse: () => NotDefinition(),
    );

    if (exist.runtimeType == RecordDefinition) {
      linked.remove(exist);
      linked.insert(0, exist);
    } else {
      RecordDefinition definition = RecordDefinition();
      definition.idx = event.idx;
      definition.value = event.text;
      definition.length = event.text.length;
      definition.selected = false;
      definition.hash = textHashValue;
      linked.insert(0, definition);
    }

    notifyListeners();
  }

  void toggleSelection(String idx) {
    for (var record in linked) {
      if (record.idx == idx) {
        record.selected = true;
      } else {
        record.selected = false;
      }
    }

    notifyListeners();
  }

  void loadRecords() {
    linked.clear();

    DatabaseHandler.instance.getAll().then((value) {
      for (ClipboardEntity clipboards in value) {
        RecordDefinition definition = RecordDefinition();
        definition.idx = clipboards.idx;
        definition.value = DatabaseHandler.utf8codec.decode(
          clipboards.content,
          allowMalformed: true,
        );
        definition.length = clipboards.size;
        definition.selected = false;
        linked.add(definition);
      }

      notifyListeners();
    });
  }

  void clear() {
    linked.clear();
    notifyListeners();
  }
}
