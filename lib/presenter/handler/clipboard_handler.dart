import 'dart:async';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:fast_clipboard/presenter/database/database_handler.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/presenter/handler/id_handler.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:pasteboard/pasteboard.dart';

class ClipboardHandler {
  ClipboardHandler._();

  static final ClipboardHandler _instance = ClipboardHandler._();

  static ClipboardHandler get instance => _instance;

  String? _lastData;
  Uint8List? _lastImage;
  List<String>? _lastFiles;

  Future<void> startMonitoring() async {
    Timer.periodic(Duration(milliseconds: 10), (timer) async {
      try {
        final currentData = await Pasteboard.text;
        final currentImage = await Pasteboard.image;
        final currentFiles = await Pasteboard.files();
        if (_lastData != currentData) {
          _lastData = currentData;
          EventHandler.instance.publish(
            RecordEvent(
              idx: IdHandler.instance.next(),
              type: 'text',
              text: DatabaseHandler.utf8codec.encode(_lastData!),
            ),
          );
        } else if (_lastImage != currentImage) {
          _lastImage = currentImage;
          EventHandler.instance.publish(
            RecordEvent(
              idx: IdHandler.instance.next(),
              type: 'image',
              text: _lastImage!,
            ),
          );
        } else if (_lastFiles != currentFiles && currentFiles.isNotEmpty) {
          _lastFiles = _lastFiles;
          EventHandler.instance.publish(
            RecordEvent(
              idx: IdHandler.instance.next(),
              type: 'file',
              text: _lastImage!,
            ),
          );
        }
      } catch (e) {
        LoggerHandler.instance.info(e.toString());
      }
    });
  }

  Future<void> copy(String value, type) async {
    await FlutterClipboard.copy(value);
  }
}
