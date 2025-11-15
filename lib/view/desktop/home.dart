import 'package:fast_clipboard/presenter/event/event_handler.dart';
import 'package:fast_clipboard/presenter/event/inapp_copy_event.dart';
import 'package:fast_clipboard/presenter/event/record_event.dart';
import 'package:fast_clipboard/presenter/provider/record_proxy_provider.dart';
import 'package:fast_clipboard/presenter/storage/database_handler.dart';
import 'package:fast_clipboard/view/desktop/data_view.dart';
import 'package:fast_clipboard/view/desktop/toolbar.dart';
import 'package:fast_clipboard/view/theme/view_region.dart';
import 'package:fast_clipboard/view/widgets/framework_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class FastClipboardHomePage extends StatefulWidget {
  const FastClipboardHomePage({super.key});

  @override
  State<FastClipboardHomePage> createState() => _FastClipboardHomePageState();
}

class _FastClipboardHomePageState
    extends FrameworkStateListener<FastClipboardHomePage> {
  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.addPostFrameCallback((c) {
      EventHandler.instance.eventBus.on<RecordEvent>().listen((event) async {
        Provider.of<RecordProxyProvider>(
          context,
          listen: false,
        ).addRecord(event);
        await databaseHandler.insert(event);
      });

      EventHandler.instance.eventBus.on<InAppCopyEvent>().listen((event) async {
        Provider.of<RecordProxyProvider>(
          context,
          listen: false,
        ).copyRecord(event);
      });

      Provider.of<RecordProxyProvider>(context, listen: false).loadRecords();
    });
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
              DataView(),
            ],
          ),
        ),
      ),
    );
  }
}
