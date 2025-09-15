import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/view/widgets/currently_connectivity.dart';
import 'package:fast_clipboard/view/widgets/hardware_detect.dart';
import 'package:fast_clipboard/view/widgets/system_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DeviceSummary extends StatefulWidget {
  const DeviceSummary({super.key});

  @override
  State<StatefulWidget> createState() => DeviceSummaryState();
}

class DeviceSummaryState extends State<DeviceSummary> {
  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: PlatformDetect.isDesktop() ? 10 : 0,
        bottom: 10,
      ),
      elevation: 0,
      color: HexColor('#f5f5f5'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlatformDetect.isDesktop()
              ? SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: PlatformDetect.isDesktop()
                          ? Row(
                              children: [
                                IconButton(
                                  tooltip: '设置',
                                  onPressed: () {
                                    GoRouter.of(context).push('/settings');
                                  },
                                  icon: Icon(
                                    LucideIcons.settings2300,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  tooltip: '历史记录',
                                  onPressed: () {
                                    GoRouter.of(context).push('/history');
                                  },
                                  icon: Icon(
                                    LucideIcons.folderClock300,
                                    size: 22,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              mainAxisAlignment: PlatformDetect.isDesktop()
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlatformDetect.isDesktop() ? Gap(80) : Container(),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(alignment: Alignment.center, child: HardwareDetect()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CurrentlyConnectivity(),
                    ),
                  ],
                ),
                SystemSummary(),
              ],
            ),
          ),
          PlatformDetect.isDesktop()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      autofocus: false,
                      onTap: () async {
                        // GoRouter.of(context).push('/transfer');

                        // HttpServerClientHandler.instance.downloadFile(
                        //   url: 'http://127.0.0.1:8080/file',
                        //   saveFileName: 'test.zip',
                        //   onProgress: (received, total) {
                        //     print(received);
                        //   },
                        // );
                      },
                      title: Text('发送文件到设备'),
                      trailing: Icon(LucideIcons.sendHorizontal300, size: 22),
                    ),
                    Gap(10),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
