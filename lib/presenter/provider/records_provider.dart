import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/model/record_definition.dart';
import 'package:fast_clipboard/presenter/database/database_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/handler/clipboard_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:window_manager/window_manager.dart';

class RecordsProvider with ChangeNotifier {
  final List<RecordDefinition> linked = [];

  List<RecordDefinition> get records => linked;

  void addRecord(RecordEvent event) {
    String textHashValue = hashlib.md5.convert(event.text).toString();
    RecordDefinition? exist = linked.firstWhere(
      (element) =>
          element.hash == textHashValue &&
          element.length == event.text.length &&
          element.value == event.text,
      orElse: () => NotDefinition(),
    );

    if (exist.runtimeType == RecordDefinition) {
      linked.remove(exist);
      _addRecord(exist);
    } else {
      RecordDefinition definition = RecordDefinition();
      definition.idx = event.idx;
      definition.value = event.text;
      definition.length = event.text.length;
      definition.selected = false;
      definition.hash = textHashValue;
      definition.updated = DateTime.now();
      definition.type = event.type;
      _addRecord(definition);
    }

    notifyListeners();
  }

  Future<void> _addRecord(RecordDefinition definition) async {
    if (!(await windowManager.isVisible())) {
      linked.insert(0, definition);
    }
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
        definition.value = clipboards.content;
        definition.length = clipboards.size;
        definition.selected = false;
        definition.updated = clipboards.updatedAt;
        definition.type = clipboards.type;
        linked.add(definition);
      }

      notifyListeners();
    });
  }

  void clear() {
    linked.clear();
    notifyListeners();
  }

  void copyRecord(InAppCopyEvent event) {
    for (var record in linked) {
      if (record.selected) {
        ClipboardHandler.instance.copy(
          DatabaseHandler.utf8codec.decode(record.value, allowMalformed: true),
          'text/plain',
        );
      }
    }

    notifyListeners();
  }
}
