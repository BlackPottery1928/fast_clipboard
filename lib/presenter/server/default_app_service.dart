import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DefaultAppService {
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(2562, 420),
      center: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      alwaysOnTop: true,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
