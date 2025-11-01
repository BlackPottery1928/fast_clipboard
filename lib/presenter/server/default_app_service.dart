import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class DefaultAppService {
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(2562, 420),
      skipTaskbar: true,
      alwaysOnTop: true,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // 系统托盘
    if (PlatformDetect.isDesktop()) {
      await trayManager.setIcon('asserts/hamof-6sdre-001.ico');
      Menu menu = Menu(
        items: [
          MenuItem(
            key: 'show_window',
            label: '显示主页面',
            onClick: (menuItem) async {
              await windowManager.show(inactive: true);
            },
          ),
          MenuItem(
            key: 'auto_start_boot',
            label: '开机自启动',
            checked: false,
            onClick: (menuItem) {},
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            label: '退出',
            onClick: (menuItem) async {
              await windowManager.destroy();
              await hotKeyManager.unregisterAll();
            },
          ),
        ],
      );
      await trayManager.setContextMenu(menu);

      // 热键
      HotKey hotKey = HotKey(
        identifier: 'fast_clipboard_app_hotkey_show_and_hide',
        key: PhysicalKeyboardKey.keyV,
        modifiers: [HotKeyModifier.control, HotKeyModifier.alt],
        scope: HotKeyScope.system,
      );

      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (hotKey) async {
          // if (kDebugMode) {
          //   print('onKeyDown+${hotKey.toJson()}');
          // }

          if (await windowManager.isVisible()) {
            await windowManager.hide();
          } else {
            await windowManager.show(inactive: true);
          }
        },
      );
    }
  }
}
