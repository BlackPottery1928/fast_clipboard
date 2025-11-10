import 'package:flutter/foundation.dart';

class LoggerHandler {
  LoggerHandler._();

  static final LoggerHandler _instance = LoggerHandler._();

  static LoggerHandler get instance => _instance;

  void info(dynamic message) {
    if (kDebugMode) {
      print(message);
    }
  }

  void error(dynamic message) {
    if (kDebugMode) {
      print(message);
    }
  }
}

final logger = LoggerHandler.instance;
