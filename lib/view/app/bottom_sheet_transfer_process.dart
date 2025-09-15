import 'dart:io';

import 'package:fast_clipboard/common/device.dart';
import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/presenter/event/file_process_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as path;

class BottomSheetTransferProcess extends StatefulWidget {
  const BottomSheetTransferProcess({super.key});

  @override
  State<StatefulWidget> createState() => BottomSheetTransferProcessState();
}

class BottomSheetTransferProcessState
    extends State<BottomSheetTransferProcess> {
  final List<File> files = [];
  double process = 0;
  int received = 0;
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );
    files.add(
      File('C:\\Users\\wangwei\\Downloads\\flutter_windows_3.35.1-stable.zip'),
    );

    ServicesBinding.instance.addPostFrameCallback((_) {
      EventHandler.instance.eventBus.on<FileProcessEvent>().listen((event) {
        setState(() {
          received = int.parse(event.received);
          total = int.parse(event.total);
          process = double.parse(event.received) / double.parse(event.total);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#edf0f2'),
        appBar: PlatformDetect.isDesktop()
            ? null
            : AppBar(
                backgroundColor: HexColor('#edf0f2'),
                title: Text('正在发送'),
                leading: SizedBox.shrink(),
                leadingWidth: 0,
                centerTitle: true,
                actions: [],
              ),
        body: SafeArea(
          child: Card(
            margin: EdgeInsets.only(
              bottom: 10,
              top: PlatformDetect.isDesktop() ? 10 : 0,
              right: 10,
              left: 10,
            ),
            elevation: 0,
            color: HexColor('#f5f5f5'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: []),
                Container(
                  width: 180,
                  height: 180,
                  alignment: Alignment.center,
                  child: Container(
                    width: 160,
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey.shade300),
                      backgroundBlendMode: BlendMode.color,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: .9,
                          constraints: BoxConstraints(
                            minWidth: 170,
                            minHeight: 170,
                          ),
                        ),
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Device.getDeviceIcon(), size: 52),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24),
                FutureBuilder<Map<String, String>>(
                  future: Device.getDeviceInfo(),
                  builder: (context, snapshot) {
                    return SizedBox(
                      child: Text(
                        snapshot.data?['deviceName'] ?? '未知设备',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      label: Text('暂停'),
                      icon: Icon(LucideIcons.pause300, size: 16),
                    ),
                    Gap(24),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        GoRouter.of(context).push("/");
                        print(111);
                      },
                      label: Text('取消'),
                      icon: Icon(LucideIcons.unlink2300, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFileNameWithExtension(String filePath) {
    return path.basename(filePath);
  }
}
