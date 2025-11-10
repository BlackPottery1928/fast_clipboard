import 'dart:math';

import 'package:uuid/uuid.dart';

class IdHandler {
  IdHandler._();

  final Uuid _uuid = Uuid();

  static final IdHandler _instance = IdHandler._();

  static IdHandler get instance => _instance;

  final Random _random = Random.secure();
  final String _alphabet = '0123456789';

  String next() {
    return _uuid.v4().replaceAll('_', '').toUpperCase();
  }

  int nextNumId(len) {
    if (len == 1) {
      return _random.nextInt(_alphabet.length);
    }

    String tmp = '';
    for (var i = 0; i < len; i++) {
      tmp += _alphabet[_random.nextInt(_alphabet.length)];
    }

    return int.parse(tmp);
  }

  int nextShowId() {
    return nextNumId(8);
  }
}

final IdHandler idHandler = IdHandler.instance;
