import 'package:fast_clipboard/presenter/clipboard/clipboard_handler.dart';
import 'package:fast_clipboard/presenter/database/database_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class AppManager {
  Future<void> initialized() async {
    WidgetsFlutterBinding.ensureInitialized();

    await DatabaseHandler.instance.create();

    ClipboardHandler.instance.startMonitoring();

    // 系统托盘
    await windowManager.ensureInitialized();

    // 窗口设置
    Display display = await screenRetriever.getPrimaryDisplay();
    WindowOptions windowOptions = WindowOptions(
      size: Size(display.size.width, ViewRegion.scaffoldHeight),
      skipTaskbar: true,
      alwaysOnTop: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPosition(
        Offset(0, display.size.height - ViewRegion.scaffoldHeight),
      );
      await windowManager.hide();
    });

    await trayManager.setIcon('asserts/tray-logo.ico');
    await trayManager.setToolTip("FastClipboard");
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: '显示主页面',
          onClick: (menuItem) async {
            if (!await windowManager.isVisible()) {
              await windowManager.show(inactive: true);
            }
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
        if (await windowManager.isVisible()) {
          await windowManager.hide();
        } else {
          await windowManager.show(inactive: true);
        }
      },
    );

    // 热键
    HotKey hotKeyCopy = HotKey(
      identifier: 'fast_clipboard_app_hotkey_copy',
      key: PhysicalKeyboardKey.keyC,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp,
    );

    await hotKeyManager.register(
      hotKeyCopy,
      keyDownHandler: (hotKey) async {
        EventHandler.instance.publish(InAppCopyEvent());
      },
    );

    // 热键
    HotKey hotKeyEsc = HotKey(
      identifier: 'fast_clipboard_app_hotkey_esc',
      key: PhysicalKeyboardKey.escape,
      modifiers: [],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      hotKeyEsc,
      keyDownHandler: (hotKey) async {
        if (await windowManager.isVisible()) {
          await windowManager.hide();
        }
      },
    );
  }
}

final appManager = AppManager();
