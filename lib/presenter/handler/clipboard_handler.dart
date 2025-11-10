import 'dart:async';

import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/presenter/handler/id_handler.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:flutter/foundation.dart';
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

          RecordEvent event = RecordEvent();
          event.idx = idHandler.next();
          event.type = 'text';
          event.text = _lastData ?? '';
          eventHandler.publish(event);
        } else if (_lastImage != currentImage) {
          _lastImage = currentImage;

          RecordEvent event = RecordEvent();
          event.idx = idHandler.next();
          event.type = 'image';
          event.image = currentImage!;

          eventHandler.publish(event);
        } else if (currentFiles.isNotEmpty) {
          if (listEquals(_lastFiles, currentFiles)) {
            return;
          }

          // print(currentFiles);
          _lastFiles = currentFiles;

          RecordEvent event = RecordEvent();
          event.idx = idHandler.next();
          event.type = 'file';
          event.files = currentFiles;
          eventHandler.publish(event);
        }
      } catch (e) {
        logger.info(e.toString());
      }
    });
  }

  Future<void> copy(String value, type) async {
    Pasteboard.writeText(value);
  }

  Future<void> copyFiles(List<String> value) async {
    Pasteboard.writeFiles(value);
  }
}

final ClipboardHandler clipboardHandler = ClipboardHandler.instance;
