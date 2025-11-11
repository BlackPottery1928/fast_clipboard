import 'package:hashlib/hashlib.dart' as hashlib;

class HashValue {
  static String generateHash(List<int> data) {
    return hashlib.sha256.convert(data).toString();
  }
}
