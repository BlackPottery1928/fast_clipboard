import 'package:fast_clipboard/model/entry/clipboards.dart';
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

    RecordDefinition? tmp;
    for (var element in linked) {
      if (element.hash == textHashValue &&
          element.length == event.text.length &&
          element.value == event.text) {
        tmp = element;
        break;
      }
    }

    if (tmp != null) {
      final index = linked.indexOf(tmp);
      if (index != -1 && index != 0) {
        linked.removeAt(index);
        linked.insert(0, tmp);
      }
    } else {
      RecordDefinition definition = RecordDefinition();
      definition.idx = event.idx;
      definition.value = event.text;
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
      for (Clipboards clipboards in value) {
        RecordDefinition definition = RecordDefinition();
        definition.idx = clipboards.idx;
        definition.value = clipboards.recordContent.target!.content;
        definition.length = clipboards.recordContent.target!.length;
        definition.selected = false;
        linked.add(definition);
      }

      notifyListeners();
    });
  }
}
