import 'package:fast_clipboard/presenter/storage/database_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/event/event_handler.dart';
import 'package:fast_clipboard/presenter/provider/records_provider.dart';
import 'package:fast_clipboard/view/page/infinite_list_view.dart';
import 'package:fast_clipboard/view/page/toolbar.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class FastClipboardHomePage extends StatefulWidget {
  const FastClipboardHomePage({super.key});

  @override
  State<FastClipboardHomePage> createState() =>
      _FastClipboardHomePageState();
}

class _FastClipboardHomePageState extends State<FastClipboardHomePage>
    with TickerProviderStateMixin, TrayListener, WindowListener {
  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);

    ServicesBinding.instance.addPostFrameCallback((c) {
      EventHandler.instance.eventBus.on<RecordEvent>().listen((event) async {
        Provider.of<RecordsProvider>(context, listen: false).addRecord(event);
        await databaseHandler.insert(event);
      });

      EventHandler.instance.eventBus.on<InAppCopyEvent>().listen((event) async {
        Provider.of<RecordsProvider>(context, listen: false).copyRecord(event);
      });

      Provider.of<RecordsProvider>(context, listen: false).loadRecords();
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F5F5F7'),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Divider(
                height: ViewRegion.scaffoldWindowBorderHeight,
                color: Colors.black26,
              ),
              Toolbar(),
              InfiniteListView(),
            ],
          ),
        ),
      ),
    );
  }
}
