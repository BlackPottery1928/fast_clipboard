import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:fast_clipboard/presenter/handler/http_server/http_ws_handler.dart';
import 'package:fast_clipboard/presenter/handler/http_server/request.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpServerHandler {
  // 单例模式实现
  HttpServerHandler._();

  static final HttpServerHandler _instance = HttpServerHandler._();

  static HttpServerHandler get instance => _instance;

  final Router _router = Router();

  late HttpServer _server;

  // 处理文件请求的核心方法
  Future<Response> _handleFileDownloadRequest(Request request) async {
    try {
      final file = File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip');

      // 检查文件是否存在
      if (!await file.exists()) {
        return Response.notFound('文件不存在: $file.path');
      }

      // 读取文件内容
      final content = await file.readAsBytes();

      // 获取文件MIME类型
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      // 构建并返回响应
      return Response.ok(
        content,
        headers: {
          'Content-Type': mimeType,
          'Content-Length': content.length.toString(),
          'Content-Disposition':
              'attachment; filename="${path.basename(file.path)}"',
        },
      );
    } catch (e) {
      return Response.internalServerError(body: '读取文件失败: ${e.toString()}');
    }
  }

  Future<void> _httpServerHandler(HttpServerIsolateParams params) async {
    // 根路径
    _router.get('/', (Request request) {
      return Response.ok('Welcome to FastSend Server!');
    });

    // 下载文件
    _router.get('/file', _handleFileDownloadRequest);

    // 注册 WebSocket 路由
    _router.get(
      '/ws',
      webSocketHandler(
        (WebSocketChannel webSocket, String? subprotocol) =>
            HttpWebSocketHandler.instance.httpWebSocketHandler(
              webSocket,
              subprotocol,
              params.sendPort,
              params.rootIsolateToken,
            ),
      ),
    );

    // 404处理
    _router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('请求错误');
    });

    final pipeline = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(
          corsHeaders(
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': '*',
            },
          ),
        )
        .addHandler(_router.call);

    _server = await shelf_io.serve(pipeline, params.address, params.port);
    params.sendPort.send(true);
  }

  // 启动服务器
  Future<void> start({String address = '0.0.0.0', int port = 8080}) async {
    ReceivePort receivePort = ReceivePort();
    final HttpServerIsolateParams params = HttpServerIsolateParams(
      address,
      port,
      receivePort.sendPort,
      ServicesBinding.rootIsolateToken!,
    );

    await Isolate.spawn(_httpServerHandler, params);

    await for (var result in receivePort) {
      if (result) {
        LoggerHandler.instance.info(
          'HttpServer running on http://$address:$port',
        );
        break;
      }
    }
  }

  // 停止服务器
  Future<void> stop() async {
    await _server.close();
    print('Server stopped');
  }
}
