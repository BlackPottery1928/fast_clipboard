import 'package:fast_clipboard/model/entry/clipboards.dart';
import 'package:fast_clipboard/model/entry/record_content.dart';
import 'package:fast_clipboard/model/objectbox.g.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHandler {
  DatabaseHandler._();

  static final DatabaseHandler _instance = DatabaseHandler._();

  static DatabaseHandler get instance => _instance;

  /// The Store of this app.
  late final Store store;
  late final Box<Clipboards> clipboardBox;
  late final Box<RecordContent> recordBox;

  Future<void> create() async {
    final docsDir = await getApplicationCacheDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "obx-clipboard"),
    );

    this.store = store;
    clipboardBox = store.box<Clipboards>();
    recordBox = store.box<RecordContent>();
  }

  Future<void> insert(RecordEvent event) async {
    String textHashValue = hashlib.md5.convert(event.text.codeUnits).toString();
    RecordContent? tmp = recordBox
        .query(RecordContent_.hash.equals(textHashValue))
        .build()
        .findFirst();
    if (tmp != null &&
        event.text.length == tmp.length &&
        event.text == tmp.content) {
      if (tmp.clipboards.hasValue) {
        // tmp.clipboards.target?.updatedAt = DateTime.now();
        // clipboardBox.put(tmp.clipboards.target, mode: PutMode.update);
        print(tmp.clipboards.targetId);
        return;
      }
      return;
    }

    RecordContent record = RecordContent();
    record.content = event.text;
    record.length = event.text.length;
    record.hash = textHashValue;
    recordBox.put(record);

    Clipboards clipboardItem = Clipboards();
    clipboardItem.idx = event.idx;
    clipboardItem.type = 'text';
    clipboardItem.createdAt = DateTime.now();
    clipboardItem.updatedAt = DateTime.now();
    clipboardItem.recordContent.target = record;

    store.box<Clipboards>().put(clipboardItem);
  }

  Future<void> clear() async {
    clipboardBox.removeAll();
  }

  Future<void> update() async {
    Clipboards clipboardItem = Clipboards();
    store.box<Clipboards>().put(clipboardItem);
  }

  Future<List<Clipboards>> getAll() async {
    Query<Clipboards> query = clipboardBox
        .query()
        .order(Clipboards_.updatedAt)
        .build();

    return query.find();
  }
}
