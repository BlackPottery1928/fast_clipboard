import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';

class ClipboardHandler {
  ClipboardHandler._();

  static final ClipboardHandler _instance = ClipboardHandler._();

  static ClipboardHandler get instance => _instance;

  String? _lastData;

  Timer? _monitoringTimer;

  void onClipboardChanged(EnhancedClipboardData data) {
    print('Clipboard changed: ${data.text}');
  }

  Future<void> startMonitoring() async {
    Timer.periodic(Duration(milliseconds: 100), (timer) async {
      try {
        if (await FlutterClipboard.hasData()) {
          final currentData = await FlutterClipboard.paste();
          if (_lastData != currentData) {
            _lastData = currentData;

            EventHandler.instance.publish(RecordEvent(currentData));
          }
        }
      } catch (e) {}
    });
  }
}
