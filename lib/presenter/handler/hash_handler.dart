import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:uuid/uuid.dart';

class HashHandler {
  HashHandler._();

  static final HashHandler _instance = HashHandler._();

  static HashHandler get instance => _instance;

  String generateHash(List<int> data) {
    return hashlib.sha256.convert(data).toString();
  }
}

final HashHandler hashHandler = HashHandler.instance;
