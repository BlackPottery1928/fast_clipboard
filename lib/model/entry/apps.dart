import 'package:objectbox/objectbox.dart';

@Entity()
class Apps {
  @Id()
  int id;
  final String name;
  final String icon;
  final String url;

  Apps(this.id, {required this.name, required this.icon, required this.url});
}
