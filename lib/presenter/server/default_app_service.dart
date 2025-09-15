import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/model/local_device.dart';
import 'package:fast_clipboard/presenter/handler/http_server/http_server_handler.dart';
import 'package:fast_clipboard/presenter/handler/mdns/multicast_handler.dart';
import 'package:fast_clipboard/presenter/handler/mdns/register_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class DefaultAppService {
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (PlatformDetect.isMobile()) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    // 设置为最高刷新率
    // await FlutterDisplayMode.setHighRefreshRate();

    startFileServer();
    // startMulticastServer();
  }

  static Future<void> startMulticastServer() async {
    // 启动多播服务
    LocalDevice device = await RegisterHandler.instance.getLocalDevice();
    await MulticastServerHandler.instance.startup(device.toMap());
    await MulticastClientHandler.instance.discover();
  }

  static Future<void> startFileServer() async {
    // final Directory? downloadsDir = await getDownloadsDirectory();
    // await FileTransferHandler.instance.startFileServer(
    //   directory: downloadsDir!,
    // );

    await HttpServerHandler.instance.start();
  }
}
