import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/model/contract/record_proxy.dart';
import 'package:fast_clipboard/model/converters/entry_record_converter.dart';
import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/presenter/clipboard/clipboard_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/storage/database_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

class RecordProxyProvider with ChangeNotifier {
  late RecordProxy current;
  final List<RecordProxy> proxys = [];

  List<RecordProxy> get records => proxys;

  void addRecord(RecordEvent event) {
    RecordProxy? exist;
    for (var element in proxys) {
      if (element.hash == event.hash) {
        exist = element;
        break;
      }
    }

    if (exist != null) {
      proxys.remove(exist);
      _addRecord(exist);
    } else {
      RecordDefinition definition = EntryRecordConverter.toDefinition(event);
      RecordProxy proxy = EntryRecordConverter.fromDefinition(definition);
      _addRecord(proxy);
    }

    notifyListeners();
  }

  Future<void> _addRecord(RecordProxy definition) async {
    if (!(await windowManager.isVisible())) {
      proxys.insert(0, definition);
    }
  }

  void toggleSelection(String idx) {
    for (var record in proxys) {
      if (record.index == idx) {
        record.selected = true;
        current = record;
      } else {
        record.selected = false;
      }
    }

    notifyListeners();
  }

  void loadRecords() {
    proxys.clear();

    DatabaseHandler.instance.getAll().then((value) {
      for (ClipboardEntity clipboards in value) {
        RecordDefinition definition = EntryRecordConverter.fromEntity(
          clipboards,
        );
        RecordProxy proxy = RecordProxy();
        proxy.definition = definition;
        proxy.index = clipboards.idx;
        proxy.selected = false;
        proxy.hash = definition.hash;
        proxys.add(proxy);
      }

      notifyListeners();
    });
  }

  void clear() {
    proxys.clear();
    notifyListeners();
  }

  void copyRecord(InAppCopyEvent event) async {
    await clipboardHandler.paste(current.definition);
  }
}
