import 'dart:typed_data';

import 'package:fast_clipboard/model/contract/record_definition.dart';
import 'package:fast_clipboard/model/contract/record_proxy.dart';
import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/storage/database_handler.dart';

class EntryRecordConverter {
  static RecordDefinition fromEntity(ClipboardEntity entry) {
    RecordDefinition definition = RecordDefinition();
    definition.index = entry.idx;
    definition.length = entry.size;
    definition.updated = entry.updatedAt;
    definition.type = entry.type;
    definition.hash = entry.hash;
    // 处理格式数据
    if (entry.type == 'text') {
      definition.text = databaseHandler.utf8codec.decode(
        entry.content,
        allowMalformed: true,
      );
    } else if (entry.type == 'image') {
      definition.image = entry.content;
    } else if (entry.type == 'file') {
      definition.files = uint8ListToStringList(entry.content);
    }
    return definition;
  }

  static List<String> uint8ListToStringList(Uint8List uint8List) {
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

  static RecordProxy fromDefinition(RecordDefinition definition) {
    RecordProxy proxy = RecordProxy();
    proxy.index = definition.index;
    proxy.hash = definition.hash;
    proxy.definition = definition;
    proxy.selected = false;
    return proxy;
  }

  static RecordDefinition toDefinition(RecordEvent event) {
    RecordDefinition definition = RecordDefinition();
    definition.index = event.idx;
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

    return definition;
  }
}
