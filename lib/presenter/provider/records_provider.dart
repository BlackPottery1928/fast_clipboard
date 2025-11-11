import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/model/record_definition.dart';
import 'package:fast_clipboard/presenter/storage/database_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/clipboard/clipboard_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

class RecordsProvider with ChangeNotifier {
  final List<RecordDefinition> linked = [];

  List<RecordDefinition> get records => linked;

  void addRecord(RecordEvent event) {
    RecordDefinition? exist = linked.firstWhere(
      (element) => element.hash == event.hash,
      orElse: () => NotDefinition(),
    );

    if (exist.runtimeType == RecordDefinition) {
      linked.remove(exist);
      _addRecord(exist);
    } else {
      RecordDefinition definition = RecordDefinition();
      definition.idx = event.idx;
      definition.selected = false;
      definition.hash = event.hash;
      definition.updated = DateTime.now();
      definition.type = event.type;

      if (event.type == "text") {
        definition.text = event.text;
        definition.length = event.text.length;
      } else if (event.type == "image") {
        definition.image = event.image;
        definition.length = event.image.length;
      } else if (event.type == "file") {
        definition.files = event.files;
        definition.length = event.files.length;
      }

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
        definition.length = clipboards.size;
        definition.selected = false;
        definition.updated = clipboards.updatedAt;
        definition.type = clipboards.type;
        // 处理格式数据
        if (clipboards.type == 'text') {
          definition.text = databaseHandler.utf8codec.decode(
            clipboards.content,
            allowMalformed: true,
          );
        } else if (clipboards.type == 'image') {
          definition.image = clipboards.content;
        } else if (clipboards.type == 'file') {
          definition.files = uint8ListToStringList(clipboards.content);
        }

        linked.add(definition);
      }

      notifyListeners();
    });
  }

  void clear() {
    linked.clear();
    notifyListeners();
  }

  void copyRecord(InAppCopyEvent event) async {
    for (var record in linked) {
      if (record.selected) {
        if (record.type == 'text') {
          clipboardHandler.copy(record.text, 'text/plain');
        } else if (record.type == 'image') {
          await clipboardHandler.copyImage(record.image);
        } else if (record.type == 'file') {
          clipboardHandler.copyFiles(record.files);
        }
      }
    }

    notifyListeners();
  }

  List<String> uint8ListToStringList(Uint8List uint8List) {
    // 1. 处理空字节（返回空列表）
    if (uint8List.isEmpty) return [];

    try {
      // 2. UTF-8 解码为完整字符串
      final combinedStr = databaseHandler.utf8codec.decode(uint8List);

      // 3. 按 \x00 分隔符拆分，还原 List<String>
      return combinedStr.split(',');
    } catch (e) {
      // 处理解码失败（如字节数据不合法）
      print('解码失败：$e');
      return []; // 或返回默认值、抛出异常
    }
  }
}
