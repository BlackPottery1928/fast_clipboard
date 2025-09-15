import 'package:fast_clipboard/common/platform_detect.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#edf0f2'),
      appBar: PlatformDetect.isDesktop()
          ? null
          : AppBar(
              backgroundColor: HexColor('#edf0f2'),
              title: Text('历史记录'),
              actions: [],
            ),
      body: Card(
        margin: EdgeInsets.only(
          bottom: 10,
          top: PlatformDetect.isDesktop() ? 10 : 0,
          right: 10,
          left: 10,
        ),
        elevation: 0,
        color: HexColor('#f5f5f5'),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        PlatformDetect.isDesktop()
                            ? IconButton(
                                onPressed: () {
                                  GoRouter.of(context).pop();
                                },
                                icon: Icon(LucideIcons.x300, size: 22),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
