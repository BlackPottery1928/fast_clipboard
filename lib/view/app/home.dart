import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_picker.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/view/app/bottom_sheet_picker.dart';
import 'package:fast_clipboard/view/app/device_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'bottom_sheet_transfer_process.dart';
import 'device_summary.dart';

class FastSendDesktopHomePage extends StatefulWidget {
  const FastSendDesktopHomePage({super.key});

  @override
  State<FastSendDesktopHomePage> createState() =>
      _FastSendDesktopHomePageState();
}

class _FastSendDesktopHomePageState extends State<FastSendDesktopHomePage>
    with TickerProviderStateMixin {
  final MultiSplitViewController _multiSplitViewController =
      MultiSplitViewController(
        areas: [
          // Area(
          //   id: 'DevicSummary',
          //   flex: PlatformDetect.isDesktop() ? 2.5 : 2,
          //   builder: (context, area) => DeviceSummary(),
          // ),
          Area(
            id: 'DeviceScan',
            builder: (context, area) => DeviceScan(),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.addPostFrameCallback((c) {
      EventHandler.instance.eventBus.on<BottomSheetShowEvent>().listen((
        data,
      ) async {
        if (mounted) {
          if (PlatformDetect.isMobile()) {
            showModalBottomSheet(
              context: context,
              enableDrag: false,
              showDragHandle: true,
              useSafeArea: true,
              constraints: BoxConstraints(maxHeight: 300),
              backgroundColor: HexColor('#edf0f2'),
              isScrollControlled: false,
              builder: (BuildContext context) {
                return BottomSheetPicker();
              },
            );
          } else if (PlatformDetect.isDesktop()) {
            GoRouter.of(context).push('/transfer');
          }
        }
      });

      EventHandler.instance.eventBus.on<BottomSheetPickerEvent>().listen((
        data,
      ) async {
        if (mounted) {
          if (PlatformDetect.isMobile()) {
            await showModalBottomSheet(
              context: context,
              enableDrag: false,
              showDragHandle: true,
              useSafeArea: true,
              backgroundColor: HexColor('#edf0f2'),
              isScrollControlled: false,
              builder: (BuildContext context) {
                return BottomSheetTransferProcess();
              },
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#edf0f2'),
      appBar: PlatformDetect.isDesktop()
          ? null
          : AppBar(
              backgroundColor: HexColor('#edf0f2'),
              title: Text('FastSend'),
              actions: [
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push('/history');
                  },
                  icon: Icon(LucideIcons.folderClock300, size: 22),
                ),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push('/settings');
                  },
                  icon: Icon(LucideIcons.settings2300, size: 22),
                ),
              ],
            ),
      body: SafeArea(
        child: MultiSplitViewTheme(
          data: MultiSplitViewThemeData(dividerThickness: 0),
          child: MultiSplitView(
            axis: PlatformDetect.isDesktop() ? Axis.horizontal : Axis.vertical,
            resizable: false,
            controller: _multiSplitViewController,
          ),
        ),
      ),
    );
  }
}
