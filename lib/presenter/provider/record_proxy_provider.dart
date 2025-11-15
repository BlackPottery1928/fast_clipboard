import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/model/contract/record_proxy.dart';
import 'package:fast_clipboard/model/converters/entry_record_converter.dart';
import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/presenter/clipboard/clipboard_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/logger/logger.dart';
import 'package:fast_clipboard/presenter/storage/database_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

class RecordProxyProvider with ChangeNotifier {
  late RecordProxy current;
  final List<RecordProxy> proxys = [];

  List<RecordProxy> get records => proxys;

  void addRecord(RecordEvent event) {
    logger.info('event: ${event.text}');
    logger.info('event: ${event.hash}');
    RecordProxy? exist;
    for (var element in proxys) {
      if (element.hash == event.hash) {
        exist = element;
        break;
      }
    }

    if (exist == null) {
      RecordDefinition definition = EntryRecordConverter.toDefinition(event);
      RecordProxy proxy = EntryRecordConverter.fromDefinition(definition);
      proxys.insert(0, proxy);
      logger.info('addRecord: ${proxy.hash}');
    } else {
      _addRecord(exist);
    }

    notifyListeners();
  }

  Future<void> _addRecord(RecordProxy exist) async {
    bool visible = await windowManager.isVisible();
    if (visible == false) {
      proxys.removeWhere((a) {
        return a.hash == exist.hash;
      });
      proxys.insert(0, exist);
      logger.info('moveRecord: ${exist.hash}');
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
        proxy.hash = clipboards.hash;
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
