import 'dart:convert';
import 'dart:typed_data';

import 'package:fast_clipboard/model/entry/clipboard_entry.dart';
import 'package:fast_clipboard/model/generate/objectbox.g.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/common/id_generator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

class DatabaseHandler {
  DatabaseHandler._();

  static final DatabaseHandler _instance = DatabaseHandler._();

  static DatabaseHandler get instance => _instance;

  /// The Store of this app.
  late final Store store;
  late final Box<ClipboardEntity> clipboardEntityBox;

  final Utf8Codec utf8codec = Utf8Codec(allowMalformed: true);

  Future<void> create() async {
    final docsDir = await getApplicationCacheDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "obx-clipboard"),
    );

    this.store = store;
    clipboardEntityBox = store.box<ClipboardEntity>();
  }

  Future<void> insert(RecordEvent event) async {
    ClipboardEntity? entity = clipboardEntityBox
        .query(ClipboardEntity_.hash.equals(event.hash))
        .build()
        .findFirst();
    if (entity == null) {
      ClipboardEntity clipboardEntity = ClipboardEntity();
      clipboardEntity.hash = event.hash;
      clipboardEntity.idx = IdGenerator.instance.next();
      clipboardEntity.updatedAt = DateTime.now();
      clipboardEntity.type = event.type;

      if (event.type == "text") {
        clipboardEntity.content = utf8codec.encode(event.text);
        clipboardEntity.size = event.text.length;
      } else if (event.type == "image") {
        clipboardEntity.content = event.image;
        clipboardEntity.size = event.image.length;
      } else if (event.type == "file") {
        clipboardEntity.content = Uint8List.fromList(
          utf8.encode(event.files.join(',')),
        );
        clipboardEntity.size = event.files.length;
      }

      _addRecord(clipboardEntity);
    } else {
      entity.updatedAt = DateTime.now();
      _addRecord(entity);
    }
  }

  Future<void> _addRecord(ClipboardEntity entity) async {
    if (!(await windowManager.isVisible())) {
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

final DatabaseHandler databaseHandler = DatabaseHandler.instance;
