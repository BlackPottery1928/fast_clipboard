import 'package:fast_clipboard/common/device.dart';
import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/presenter/event/bottom_sheet_show_event.dart';
import 'package:fast_clipboard/presenter/event/discovery_service_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/view/widgets/flickr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DeviceScan extends StatefulWidget {
  const DeviceScan({super.key});

  @override
  State<StatefulWidget> createState() => DeviceScanState();
}

class DeviceScanState extends State<DeviceScan> {
  final Map<String, String> _deviceInfo = {};
  final List<Map<String, dynamic>> devices = [];

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.addPostFrameCallback((_) {
      _deviceInfo.clear();

      Device.getDeviceInfo().then((value) {
        setState(() {
          _deviceInfo.addAll(value);
        });
      });

      devices.add({
        'deviceName': 'Test',
        'deviceType': 'IOS',
        'uniqueId': '2222',
      });

      EventHandler.instance.eventBus.on<DiscoveryServiceEvent>().listen((
        event,
      ) {
        setState(() {
          if (!devices.any(
            (element) => element['uniqueId'] == event.data['uniqueId'],
          )) {
            devices.add(event.data);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: PlatformDetect.isDesktop() ? 10 : 10,
        bottom: 10,
        top: PlatformDetect.isDesktop() ? 10 : 0,
        right: 10,
      ),
      elevation: 0,
      color: HexColor('#f5f5f5'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '附件的设备',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    // PlatformDetect.isDesktop()
                    //     ? IconButton(
                    //         tooltip: '添加文件',
                    //         onPressed: () async {
                    //           FilePickerResult? result = await FilePicker
                    //               .platform
                    //               .pickFiles(allowMultiple: true);
                    //
                    //           if (result != null) {
                    //             for (var path in result.paths) {
                    //               print(File(path!).path);
                    //             }
                    //           } else {
                    //             // User canceled the picker
                    //           }
                    //         },
                    //         icon: Icon(LucideIcons.filePlus2300, size: 22),
                    //       )
                    //     : Container(),
                    // PlatformDetect.isDesktop()
                    //     ? IconButton(
                    //         tooltip: '添加文件夹',
                    //         onPressed: () async {
                    //           String? selectedDirectory = await FilePicker
                    //               .platform
                    //               .getDirectoryPath();
                    //           print(selectedDirectory);
                    //           if (selectedDirectory == null) {
                    //             // User canceled the picker
                    //           }
                    //         },
                    //         icon: Icon(LucideIcons.folder300, size: 22),
                    //       )
                    //     : Container(),
                    PlatformDetect.isDesktop()
                        ? IconButton(
                            tooltip: '扫描设备',
                            onPressed: () async {},
                            icon: Icon(LucideIcons.refreshCcwDot300, size: 22),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: devices.isNotEmpty,
              replacement: DeviceFound(),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Device.getDeviceIconByType(
                          devices[i]['deviceType'].toString(),
                        ),
                        size: 32,
                      ),
                    ),
                    title: Text(devices[i]['deviceName'].toString()),
                    subtitle: Text(
                      devices[i]['deviceType'].toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () async {
                      EventHandler.instance.publish(BottomSheetShowEvent());
                    },
                  );
                },
                separatorBuilder: (i, c) {
                  return Container(height: 4);
                },
                itemCount: devices.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceFound extends StatefulWidget {
  const DeviceFound({super.key});

  @override
  State<StatefulWidget> createState() => _DeviceFoundState();
}

class _DeviceFoundState extends State<DeviceFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: PlatformDetect.isDesktop()
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlatformDetect.isDesktop() ? Gap(80) : Container(),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 140,
              width: 140,
              color: Colors.white,
              child: Flickr(
                leftDotColor: Colors.white,
                rightDotColor: Colors.white,
                size: 140,
              ),
            ),
          ),
          Gap(12),
          Text(
            '正在搜索设备',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Gap(6),
          Text(
            '请确保设备在同一个局域网内',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
