import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

abstract class FrameworkStateListener<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin, TrayListener, WindowListener {
  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    if (!(await windowManager.isVisible())) {
      await windowManager.show(inactive: true);
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      // do something
    } else if (menuItem.key == 'exit_app') {
      // do something
    }
  }

  @override
  Future<void> onWindowBlur() async {
    if (await windowManager.isVisible()) {
      await windowManager.hide();
    }

    super.onWindowBlur();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }
}
