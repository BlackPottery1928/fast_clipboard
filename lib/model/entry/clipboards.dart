import 'package:fast_clipboard/model/entry/record_content.dart';
import 'package:objectbox/objectbox.dart';

import 'apps.dart';

@Entity()
class Clipboards {
  @Id()
  int id = 0;

  @Index()
  @Unique()
  late String idx;
  @Index()
  late String tag = 'default';
  late String type;
  @Property(type: PropertyType.dateNano)
  late DateTime createdAt;

  @Property(type: PropertyType.dateNano)
  late DateTime updatedAt;

  final ToOne<Apps> apps = ToOne<Apps>();
  final ToOne<RecordContent> recordContent = ToOne<RecordContent>();

  Clipboards();
}
