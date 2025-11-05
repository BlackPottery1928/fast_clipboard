import 'dart:convert';

import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/model/objectbox.g.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:fast_clipboard/presenter/handler/id_handler.dart';
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHandler {
  DatabaseHandler._();

  static final DatabaseHandler _instance = DatabaseHandler._();

  static DatabaseHandler get instance => _instance;

  /// The Store of this app.
  late final Store store;
  late final Box<ClipboardEntity> clipboardEntityBox;

  static final Utf8Codec utf8codec = Utf8Codec(allowMalformed: true);

  Future<void> create() async {
    final docsDir = await getApplicationCacheDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "obx-clipboard"),
    );

    this.store = store;
    clipboardEntityBox = store.box<ClipboardEntity>();
  }

  Future<void> insert(RecordEvent event) async {
    String textHashValue = hashlib.md5.convert(event.text.codeUnits).toString();

    ClipboardEntity? entity = clipboardEntityBox
        .query(ClipboardEntity_.hash.equals(textHashValue))
        .build()
        .findFirst();
    if (entity == null) {
      ClipboardEntity clipboardEntity = ClipboardEntity();
      clipboardEntity.hash = textHashValue;
      clipboardEntity.idx = IdHandler.instance.next();
      clipboardEntity.updatedAt = DateTime.now();
      clipboardEntity.content = utf8codec.encode(event.text);
      clipboardEntity.size = event.text.length;
      clipboardEntity.type = 'text';
      clipboardEntityBox.put(clipboardEntity);
    } else {
      entity.updatedAt = DateTime.now();
      clipboardEntityBox.put(entity);
    }
  }

  Future<void> clear() async {
    clipboardEntityBox.removeAll();
  }

  Future<List<ClipboardEntity>> getAll() async {
    Query<ClipboardEntity> query = clipboardEntityBox
        .query()
        .order(ClipboardEntity_.updatedAt, flags: Order.descending)
        .build();

    return query.find();
  }
}
