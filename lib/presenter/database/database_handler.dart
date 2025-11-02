import 'package:fast_clipboard/model/entry/clipboards.dart';
import 'package:fast_clipboard/model/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHandler {
  DatabaseHandler._();

  static final DatabaseHandler _instance = DatabaseHandler._();

  static DatabaseHandler get instance => _instance;

  /// The Store of this app.
  late final Store store;

  Future<void> create() async {
    final docsDir = await getApplicationCacheDirectory();
    print(docsDir.path);
    print((await getApplicationSupportDirectory()).path);
    final store = await openStore(
      directory: p.join(docsDir.path, "obx-clipboard"),
    );

    this.store = store;
  }

  Future<void> insert() async {
    Clipboards clipboardItem = Clipboards('11', '', '', 22);
    store.box<Clipboards>().put(clipboardItem);

    print(store.box<Clipboards>().getAll().toString());
  }
}
