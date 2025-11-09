import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/presenter/handler/id_handler.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';

class ClipboardHandler {
  ClipboardHandler._();

  static final ClipboardHandler _instance = ClipboardHandler._();

  static ClipboardHandler get instance => _instance;

  String? _lastData;

  Future<void> startMonitoring() async {
    Timer.periodic(Duration(milliseconds: 10), (timer) async {
      try {
        if (await FlutterClipboard.hasData()) {
          final currentData = await FlutterClipboard.paste();
          if (_lastData != currentData) {
            _lastData = currentData;

            EventHandler.instance.publish(
              RecordEvent(idx: IdHandler.instance.next(), text: currentData),
            );
          }
        }
      } catch (e) {
        LoggerHandler.instance.info(e.toString());
      }
    });
  }

  void copy(String value, type) {
    FlutterClipboard.copy(value);
  }
}
