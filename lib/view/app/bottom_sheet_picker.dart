import 'package:fast_clipboard/presenter/event/bottom_sheet_picker.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BottomSheetPicker extends StatefulWidget {
  const BottomSheetPicker({super.key});

  @override
  State<StatefulWidget> createState() => _BottomSheetPickerState();
}

class _BottomSheetPickerState extends State<BottomSheetPicker> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#edf0f2'),
        appBar: AppBar(
          backgroundColor: HexColor('#edf0f2'),
          title: Text('文件发送'),
          centerTitle: true,
          leading: Container(),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '选择您要发送的内容',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2 - 24,
                    height: 112,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.file300, size: 36),
                        Gap(6),
                        Text('文件'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    // FilePicker.platform.pickFiles().then((f) {
                    //   GoRouter.of(context).push('/transfer');
                    // });

                    EventHandler.instance.eventBus.fire(
                      BottomSheetPickerEvent(),
                    );

                    GoRouter.of(context).pop();
                  },
                ),
                Gap(18),
                GestureDetector(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2 - 24,
                    height: 112,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.image300, size: 36),
                        Gap(6),
                        Text('照片或视频'),
                      ],
                    ),
                  ),
                  onTap: () {
                    // FilePicker.platform.pickFiles();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
