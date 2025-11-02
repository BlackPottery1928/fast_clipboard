import 'package:objectbox/objectbox.dart';

@Entity()
class Record {
  @Id()
  int id;
  final int clipboardsId;
  final String content;

  Record(this.id, this.clipboardsId, this.content);
}
