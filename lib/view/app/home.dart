import 'package:fast_clipboard/view/app/infinite_list_view.dart';
import 'package:fast_clipboard/view/app/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class FastSendDesktopHomePage extends StatefulWidget {
  const FastSendDesktopHomePage({super.key});

  @override
  State<FastSendDesktopHomePage> createState() =>
      _FastSendDesktopHomePageState();
}

class _FastSendDesktopHomePageState extends State<FastSendDesktopHomePage>
    with TickerProviderStateMixin, TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);

    super.initState();

    ServicesBinding.instance.addPostFrameCallback((c) {});
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  Future<void> onTrayIconMouseDown() async {
    if (await windowManager.isVisible()) {
      await windowManager.hide();
    } else {
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
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#edf0f2'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Toolbar(), InfiniteListView()],
        ),
      ),
    );
  }
}
