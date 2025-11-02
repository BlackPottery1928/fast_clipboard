import 'package:objectbox/objectbox.dart';

@Entity()
class Clipboards {
  @Id()
  int id = 0;
  late String type;
  late String createdAt;
  late String updatedAt;
  @Index()
  late int appsId;

  Clipboards(this.type, this.createdAt, this.updatedAt, this.appsId);
}
