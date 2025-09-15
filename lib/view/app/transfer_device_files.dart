import 'dart:io';

import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:fast_clipboard/model/transfer_status.dart';
import 'package:fast_clipboard/presenter/provider/transfer_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class TransferDeviceFiles extends StatefulWidget {
  const TransferDeviceFiles({super.key});

  @override
  State<StatefulWidget> createState() => TransferDeviceFilesState();
}

class TransferDeviceFilesState extends State<TransferDeviceFiles> {
  Widget _buildText(BuildContext context) {
    TransferProvider transferProvider = Provider.of<TransferProvider>(context);
    if (transferProvider.status == TransferStatus.send) {
      return Text('正在发送文件');
    } else if (transferProvider.status == TransferStatus.receive) {
      return Text('正在接收文件');
    }

    return Text('选择文件');
  }

  @override
  Widget build(BuildContext context) {
    TransferProvider transferProvider = Provider.of<TransferProvider>(context);
    return Scaffold(
      backgroundColor: HexColor('#edf0f2'),
      appBar: PlatformDetect.isDesktop()
          ? null
          : AppBar(
              backgroundColor: HexColor('#edf0f2'),
              title: _buildText(context),
              leading: SizedBox.shrink(),
              leadingWidth: 0,
            ),
      body: Card(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: PlatformDetect.isDesktop() ? 10 : 0,
          bottom: 10,
        ),
        elevation: 0,
        color: HexColor('#f5f5f5'),
        child: Column(
          children: [
            _buildHeadToolbar(context),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: PlatformDetect.isDesktop()
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(24),
                    Container(
                      width: 180,
                      height: 180,
                      alignment: Alignment.center,
                      child: Container(
                        width:
                            transferProvider.status == TransferStatus.selecting
                            ? 160
                            : 170,
                        height:
                            transferProvider.status == TransferStatus.selecting
                            ? 160
                            : 170,
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
                                // color: Colors.white,
                                // shape: BoxShape.circle,
                              ),
                              child: Icon(LucideIcons.file300, size: 52),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(24),
                    Text(
                      '发送 3 个文件到 Macos Book, 剩余时间 3分10秒',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Gap(6),
                    Text(
                      '请确保设备在一个网络下',
                      style: TextStyle(
                        fontSize: 12,
                        color: HexColor('#999999'),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () {},
                          label: Text('暂停'),
                          icon: Icon(LucideIcons.pause300, size: 16),
                        ),
                        Gap(48),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          label: Text('取消'),
                          icon: Icon(LucideIcons.unlink2300, size: 16),
                        ),
                      ],
                    ),
                    Gap(10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadToolbar(BuildContext context) {
    TransferProvider transferProvider = Provider.of<TransferProvider>(context);
    return PlatformDetect.isDesktop()
        ? SizedBox(
            height: 50,
            child: transferProvider.status == TransferStatus.selected
                ? Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              GoRouter.of(context).pop();
                            },
                            icon: Icon(LucideIcons.x300, size: 22),
                          ),
                          Spacer(),
                          PlatformDetect.isDesktop()
                              ? IconButton(
                                  tooltip: '添加文件',
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(allowMultiple: true);

                                    if (result != null) {
                                      for (var path in result.paths) {
                                        print(File(path!).path);
                                      }
                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  icon: Icon(
                                    LucideIcons.filePlus2300,
                                    size: 22,
                                  ),
                                )
                              : Container(),
                          PlatformDetect.isDesktop()
                              ? IconButton(
                                  tooltip: '添加文件夹',
                                  onPressed: () async {
                                    String? selectedDirectory = await FilePicker
                                        .platform
                                        .getDirectoryPath();
                                    print(selectedDirectory);
                                    if (selectedDirectory == null) {
                                      // User canceled the picker
                                    }
                                  },
                                  icon: Icon(LucideIcons.folder300, size: 22),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '正在发送文件',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          )
        : SizedBox.shrink();
  }
}
