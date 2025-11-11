import 'dart:async';

import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/common/hash_value.dart';
import 'package:fast_clipboard/common/id_generator.dart';
import 'package:fast_clipboard/presenter/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:pasteboard/pasteboard.dart';

class ClipboardHandler {
  ClipboardHandler._();

  static final ClipboardHandler _instance = ClipboardHandler._();

  static ClipboardHandler get instance => _instance;

  late String? _lastText;
  late String? _lastTextHash;
  late int _lastTextLength = -1;

  late String _lastImageHash = '';
  late int _lastImageLength = -1;

  late List<String> _lastFiles = [];
  late int _lastFilesLength = -1;

  Future<void> startMonitoring() async {
    Timer.periodic(Duration(milliseconds: 20), (timer) async {
      try {
        final String? currentText = await Pasteboard.text;
        final Uint8List? currentImage = await Pasteboard.image;
        final List<String> currentFiles = await Pasteboard.files();

        if (currentText != null && currentText.isNotEmpty) {
          String hash = '';
          int length = currentText.length;
          if (_lastTextLength == length) {
            if (length >= 64) {
              hash = HashValue.generateHash(currentText.codeUnits);
              if (_lastTextHash == hash) {
                return;
              }
            } else {
              if (_lastText == currentText) {
                return;
              }
            }
          }

          _lastText = currentText;
          _lastTextLength = length;
          _lastTextHash = hash.isNotEmpty
              ? hash
              : HashValue.generateHash(currentText.codeUnits);

          RecordEvent event = RecordEvent();
          event.idx = idGenerator.next();
          event.type = 'text';
          event.text = _lastText ?? '';
          event.hash = _lastTextHash ?? '';

          eventHandler.publish(event);
        } else if (currentImage != null && currentImage.isNotEmpty) {
          if (_lastImageLength == currentImage.length) {
            return;
          }

          String hash = HashValue.generateHash(currentImage);
          if (hash == _lastImageHash) {
            return;
          }

          _lastImageHash = hash;
          _lastImageLength = currentImage.length;

          RecordEvent event = RecordEvent();
          event.idx = idGenerator.next();
          event.type = 'image';
          event.image = currentImage;
          event.hash = hash;

          eventHandler.publish(event);
        } else if (currentFiles.isNotEmpty) {
          if (_lastFilesLength == currentFiles.length &&
              listEquals(_lastFiles, currentFiles)) {
            return;
          }

          _lastFiles = currentFiles;
          _lastFilesLength = currentFiles.length;

          RecordEvent event = RecordEvent();
          event.idx = idGenerator.next();
          event.type = 'file';
          event.files = currentFiles;
          event.hash = HashValue.generateHash(
            currentFiles.join(',').codeUnits,
          );

          eventHandler.publish(event);
        }
      } catch (e) {
        logger.info("监听剪切板异常: ${e.toString()}");
      }
    });
  }

  Future<void> copy(String value, type) async {
    Pasteboard.writeText(value);
  }

  Future<void> copyFiles(List<String> value) async {
    Pasteboard.writeFiles(value);
  }

  Future<void> copyImage(Uint8List image) async {
    await Pasteboard.writeImage(image);
  }
}

final ClipboardHandler clipboardHandler = ClipboardHandler.instance;
