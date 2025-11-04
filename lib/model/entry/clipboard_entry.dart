import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

@Entity()
class ClipboardEntity {
  @Id()
  int id = 0;

  @Index()
  late String idx;

  @Index()
  late String tag = 'default';

  late String type;

  @Property(type: PropertyType.dateNano)
  late DateTime updatedAt;

  late String source = 'unknown';

  late Uint8List content;

  @Index()
  late String hash;

  late int size;

  ClipboardEntity();
}
