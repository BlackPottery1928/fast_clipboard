import 'package:fast_clipboard/presenter/app_manager.dart';
import 'package:fast_clipboard/presenter/provider/widget_provider_bridge.dart';
import 'package:fast_clipboard/view/fast_clipboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // 初始化配置
  await appManager.initialized();

  runApp(WidgetProviderBridge(child: FastClipboardApp()));
}
