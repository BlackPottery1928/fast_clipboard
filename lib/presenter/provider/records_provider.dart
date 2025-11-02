import 'package:fast_clipboard/model/record_definition.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:fast_clipboard/presenter/handler/id_handler.dart';
import 'package:flutter/foundation.dart';

class RecordsProvider with ChangeNotifier {
  final List<RecordDefinition> linked = [];

  List<RecordDefinition> get records => linked;

  void addRecord(RecordEvent event) {
    linked.insert(0, RecordDefinition(IdHandler.instance.next(), event.text));
    notifyListeners();
  }

  void toggleSelection(String idx) {
    for (var record in linked) {
      if (record.id == idx) {
        record.selected = true;
      } else {
        record.selected = false;
      }
    }

    notifyListeners();
  }
}
