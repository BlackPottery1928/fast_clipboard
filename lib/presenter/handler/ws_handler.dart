import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsHandler {
  WsHandler._();

  static final WsHandler _instance = WsHandler._();

  static WsHandler get instance => _instance;

  Future<void> start() async {
    // 启动WebSocket服务器，监听8080端口
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 5353);
    print('WebSocket服务器已启动，地址: ws://${server.address.host}:${server.port}');
  }
}
