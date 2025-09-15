import 'dart:async';
import 'dart:convert';

import 'package:fast_clipboard/presenter/event/file_process_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpWebSocketClientHandler {
  // 单例模式实现
  HttpWebSocketClientHandler._();

  static final HttpWebSocketClientHandler _instance =
      HttpWebSocketClientHandler._();

  static HttpWebSocketClientHandler get instance => _instance;

  Future<void> ws() async {
    final wsUrl = Uri.parse('ws://127.0.0.1:8080/ws');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.sink.add(jsonEncode({'type': 'download'}));

    channel.stream.listen((message) {
      final Map<String, dynamic> data = jsonDecode(message.toString());
      switch (data['type']) {
        case 'connected':
          LoggerHandler.instance.info('${data['message']}');
          break;
        case 'message':
          LoggerHandler.instance.info('Received message: ${data['message']}');
          break;
        case 'progress':
          LoggerHandler.instance.info(
            'Received progress: ${data['received']}/${data['total']}',
          );
          EventHandler.instance.publish(
            FileProcessEvent(
              fileId: '',
              received: data['received'].toString(),
              total: data['total'].toString(),
            ),
          );
          break;
        case 'error':
          LoggerHandler.instance.error('Received error: ${data['message']}');
          break;
        default:
          LoggerHandler.instance.error('Invalid message type');
      }
    });
  }
}
