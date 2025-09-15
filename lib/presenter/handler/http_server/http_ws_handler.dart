import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'http_server_client_handler.dart';

class HttpWebSocketHandler {
  // 单例模式实现
  HttpWebSocketHandler._();

  static final HttpWebSocketHandler _instance = HttpWebSocketHandler._();

  static HttpWebSocketHandler get instance => _instance;

  void _sendConnectedMessage(WebSocketChannel webSocket) {
    webSocket.sink.add(
      jsonEncode({
        'type': 'connected',
        'message': 'ws connected',
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }

  void httpWebSocketHandler(
    WebSocketChannel webSocket,
    String? subprotocol,
    SendPort sendPort,
    RootIsolateToken rootIsolateToken,
  ) {
    LoggerHandler.instance.info('ws connected');

    // 发送连接成功消息
    _sendConnectedMessage(webSocket);

    // 监听消息
    _subscription(webSocket, rootIsolateToken);
  }

  void _subscription(
    WebSocketChannel webSocket,
    RootIsolateToken rootIsolateToken,
  ) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // 监听来自客户端的消息
    final StreamSubscription subscription = webSocket.stream.listen((message) {
      LoggerHandler.instance.info('客户端消息: $message');
      // 解析消息并处理
      try {
        final data = jsonDecode(message.toString());
        switch ('download') {
          case 'download':
            HttpServerClientHandler.instance.downloadFile(
              url: 'http://192.168.124.3:8080/file',
              saveFileName: 'test.zip',
              onProgress: (received, total) {
                webSocket.sink.add(
                  jsonEncode({
                    'type': 'progress',
                    'received': received,
                    'total': total,
                    'timestamp': DateTime.now().toIso8601String(),
                  }),
                );


              },
            );
            break;
          case 'process':
            break;
          default:
            webSocket.sink.add(
              jsonEncode({'type': 'error', 'message': '无效的消息类型'}),
            );
        }
      } catch (e) {
        webSocket.sink.add(
          jsonEncode({'type': 'error', 'message': '无效的消息格式: ${e.toString()}'}),
        );
      }
    });

    // 处理连接关闭
    subscription.onDone(() {
      LoggerHandler.instance.info("ws disconnect");
    });

    // 处理错误
    subscription.onError((error) {
      LoggerHandler.instance.error("ws error: $error");
    });
  }
}
