import 'package:fast_clipboard/model/entry/clipboards.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RecordContent {
  @Id()
  int id = 0;
  late String content;

  @Index()
  late String hash;
  late int length = 0;

  late ToOne<Clipboards> clipboards = ToOne<Clipboards>();

  RecordContent();
}
